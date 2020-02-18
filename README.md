# nextflow-bcl

A simple [nextflow](https://www.nextflow.io/) pipeline for obtaining Illumina run metrics (InterOp) and generation of fastq files (bcl2fastq). The input is an Illumina run folder (with bcl files) and a SampleSheet.csv file. Run it with:

```bash
nextflow run angelovangel/nextflow-bcl --runfolder illumina_folder
```

The pipeline executes the Illumina programs [InterOp](https://github.com/Illumina/interop) summary and 
[bcl2fastq](https://emea.support.illumina.com/sequencing/sequencing_software/bcl2fastq-conversion-software.html) in a docker container, saves the fastq files in `results/fastq/`, and generates a [MultiQC](https://multiqc.info/) report in `results/`. That's it!  

The above command assumes SampleSheet.csv is in the Illumina runs folder.
Using the `--samplesheet` parameter, a different sample sheet can be passed. For all available parameters, try

```bash
nextflow run angelovangel/nextflow-bcl --help
``` 

I have uploaded a small test dataset on Amazon S3, to run the pipeline with it use:

```bash
nextflow run angelovangel/nextflow-bcl -profile test
# might take some time to get the data from amazon
```

And finally, if you don't have nextflow [go get it!](https://www.nextflow.io/)  
Cheers!
