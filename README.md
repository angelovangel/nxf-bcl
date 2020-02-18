# nextflow-bcl

A simple [nextflow](https://www.nextflow.io/) pipeline for obtaining Illumina run metrics (InterOp) and generation of fastq files (bcl2fastq). The input is an Illumina run folder (with bcl files) and a SampleSheet.csv file. Run it with:

```
nextflow run angelovangel/nextflow-bcl --runfolder path/to/illumina_folder
```

The above command assumes SampleSheet.csv is in the Illumina runs folder. 
You can pass a different sample sheet with the `--samplesheet` parameter. For all available parameters, try

```
nextflow run angelovangel/nextflow-bcl --help
``` 

The pipeline executes the Illumina programs [InterOp](https://github.com/OpenGene/fastp) summary and 
[bcl2fastq](), saves the fastq files in `results/fastq/`, and generates a [MultiQC](https://multiqc.info/) report in `results`. That's it!