// Interop - bcl2fastq - MultiQC pipeline

/*
* ANSI escape codes to color output messages
*/
ANSI_GREEN = "\033[1;32m"
ANSI_RED = "\033[1;31m"
ANSI_RESET = "\033[0m"

/*
 * pipeline input parameters
 */
// use bcl test data from https://github.com/roryk/tiny-test-data/tree/master/flowcell

 params.runfolder = ""
 params.samplesheet = "${params.runfolder}/SampleSheet.csv"
 params.outdir = "$workflow.launchDir/results"
 params.title = "InterOp and bcl2fastq summary"
 params.multiqc_config = "$baseDir/multiqc_config.yml" //in case ncct multiqc config needed
 params.help = ""
 params.load_threads = 4
 params.proc_threads = 4
 params.write_threads = 4 //must not be higher than number of samples

 mqc_config = file(params.multiqc_config) // this is needed, otherwise the multiqc config file is not available in the docker image

if (params.help) {
    helpMessage()
    exit(0)
}

log.info """
        ===========================================
         ${ANSI_GREEN}I N T E R O P   and   B C L 2 F A S T Q   P I P E L I N E${ANSI_RESET}

         Used parameters:
        -------------------------------------------
         --runfolder        : ${params.runfolder}
         --samplesheet      : ${params.samplesheet}
         --outdir           : ${params.outdir}
         --multiqc_config   : ${params.multiqc_config}
         --title            : ${params.title}
         --load_threads     : ${params.load_threads}
         --proc_threads     : ${params.proc_threads}
         --write_threads    : ${params.write_threads}

         Runtime data:
        -------------------------------------------
         Running with profile:   ${ANSI_GREEN}${workflow.profile}${ANSI_RESET}
         Running as user:        ${ANSI_GREEN}${workflow.userName}${ANSI_RESET}
         Launch dir:             ${ANSI_GREEN}${workflow.launchDir}${ANSI_RESET}
         Base dir:               ${ANSI_GREEN}${baseDir}${ANSI_RESET}
         Nextflow version        ${ANSI_GREEN}${nextflow.version}${ANSI_RESET}
         """
         .stripIndent()

def helpMessage() {
log.info """
        ===========================================
         ${ANSI_GREEN}I N T E R O P   and   B C L 2 F A S T Q   P I P E L I N E${ANSI_RESET}

         This pipeline takes an Illumina run output folder and runs the Illumina executables
         InterOp summary (sequencing run metrics) and bcl2fastq (converts bcl to fastq).
         By default, the file SampleSheet.csv from the runfolder is used in bcl2fastq, but another sample sheet file can be provided.
         The resulting fastq files are saved under ${ANSI_GREEN}results/fastq${ANSI_RESET}.
         The number of threads used by bcl2fastq are set to 4. If you know what you are doing,
         you can set them using the respective parameters.

         Usage:
        -------------------------------------------
         --runfolder        : Illumina run folder
         --outdir           : where results will be saved, default is "results"
         --samplesheet      : sample sheet file, default is runfolder/SampleSheet.csv
         --multiqc_config   : config file for MultiQC, default is "multiqc_config.yml"
         --title            : MultiQC report title, default is "InterOp and bcl2fastq summary"
         --load_threads     : Number of threads used for loading BCL data. 4 by default.
         --proc_threads     : Number of threads used for processing demultiplexed data. 4 by default.
         --write_threads    : number of threads used for writing FASTQ data. ${ANSI_RED}Must not be higher than number of samples!${ANSI_RESET} 4 by default.
        ===========================================
         """
         .stripIndent()

}

// in case trailing slash in runfolder not provided:
runfolder_repaired = "${params.runfolder}".replaceFirst(/$/, "/")

Channel
    .fromPath(runfolder_repaired, checkIfExists: true, type: 'dir')
    .ifEmpty { error "Can not find folder ${runfolder_repaired}" }
    .set {runfolder_ch}
Channel
    .fromPath(params.samplesheet)
    .set {samplesheet_ch}

runfolder_ch.into {runfolder_interop; runfolder_bcl}

process interop {
    tag "interop on $x"

    input:
        path x from runfolder_interop

    // path is preferred over file as an output qualifier
    output:
        path 'interop_file' into interop_ch

    script:
    """
    interop_summary --csv=1 $x > interop_file
    """
}

// I want to print the ncores and nsamples to adjust the bcl2fastq parameters in subsequent runs
process bcl {
    int ncores = Runtime.getRuntime().availableProcessors(); 

    tag "bcl2fastq, ${ncores} cores detected"
    publishDir params.outdir, mode: 'copy', pattern: '**fastq.gz'

    input:
        path x from runfolder_bcl
        path y from samplesheet_ch

    // path is preferred over file as an output qualifier
    output:
        path 'fastq/Stats/Stats.json' into bcl_ch
        path '**fastq.gz' // ** is for recursive match, directories are omitted (the fastq files might be in fastq/someproject/...)

    // default to --ignore-missing all?
    script:
    """
    bcl2fastq -R $x -o fastq \
    --sample-sheet ${params.samplesheet} \
    --no-lane-splitting \
    --ignore-missing-bcls \
    -r ${params.load_threads}
    -p ${params.proc_threads}
    -w ${params.write_threads}
    """
}

process multiqc {
    publishDir params.outdir, mode: 'copy'

    input:
        file interop_file from interop_ch
        file 'Stats.json' from bcl_ch

    output:
        file 'multiqc_report.html'

    script:
    """
    multiqc --force --interactive \
    --title "${params.title}" \
    --filename "multiqc_report.html" $interop_file Stats.json
    """
}
//=============================
workflow.onComplete {
    if (workflow.success) {
        log.info """
            ===========================================
            ${ANSI_GREEN}Finished in ${workflow.duration}
            See the report here      ==> ${ANSI_RESET}$params.outdir/multiqc_report.html${ANSI_GREEN}
            The fastq files are here ==> ${ANSI_RESET}$params.outdir/fastq/
            ===========================================
            """
            .stripIndent()
    }
    else {
        log.info """
            ===========================================
            ${ANSI_RED}Finished with errors!${ANSI_RESET}
            """
            .stripIndent()
    }
}
