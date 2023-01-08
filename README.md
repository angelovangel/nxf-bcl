# nxf-bcl

A simple [nextflow](https://www.nextflow.io/) pipeline for obtaining Illumina run metrics (InterOp) and generation of fastq files (`bcl2fastq`) from Illumina raw data. The input is an Illumina run folder (with bcl files) and a SampleSheet.csv file. The pipeline has been tested with runs from all Illumina machines. Run it with:

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

*Tip* - For generating the required sample sheet you can use the [sample sheet generator app](https://github.com/angelovangel/samplesheet-generator), and for analysis of the generated fastq files you can run the [angelovangel/nxf-fastqc](https://github.com/angelovangel/nxf-fastqc) pipeline.   

And finally, if you don't have nextflow [go get it!](https://www.nextflow.io/)  
Cheers!

*Update 08-01-2023*

Use `nextflow run -dsl1 ...`, the pipeline is still using DSL1 syntax
