# nxf-bcl

A simple [nextflow](https://www.nextflow.io/) pipeline for obtaining Illumina run metrics (InterOp) and generation of fastq files (bcl2fastq). The input is an Illumina run folder (with bcl files) and a SampleSheet.csv file. So far tested with runs from NextSeq and MiSeq machines. Run it with:

```bash
nextflow run angelovangel/nxf-bcl --runfolder illumina_folder
```

The pipeline runs in a docker container by default, so no need to install anything (except nextflow of course). It executes the Illumina programs [InterOp](https://github.com/Illumina/interop) summary and [bcl2fastq](https://emea.support.illumina.com/sequencing/sequencing_software/bcl2fastq-conversion-software.html), saves the fastq files in `results-bcl/fastq/`, and generates a [MultiQC](https://multiqc.info/) report in `results-bcl/`. That's it!  

The above command assumes SampleSheet.csv is in the Illumina runs folder.
Using the `--samplesheet` parameter, a different sample sheet can be passed. For all available parameters, try

```bash
nextflow run angelovangel/nxf-bcl --help
```

I have uploaded a small test dataset from Illumina on Amazon S3, to run the pipeline with it use:

```bash
nextflow run angelovangel/nxf-bcl -profile test
# might take some time to get the data from amazon
```

*Tip* - you can then run the [angelovangel/nxf-fastqc](https://github.com/angelovangel/nxf-fastqc) pipeline on the fastq files to get data on their quality and filter/trim them.   

And finally, if you don't have nextflow [go get it!](https://www.nextflow.io/)  
Cheers!
