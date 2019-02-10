RNAseqFungi: Detailed Manual
================

There are four parts in this document describing step by step the analysis of RNA-seq data from *Synchytrium endobioticum*.
All procedures were done on AWS cloud using several Docker containers designed for this project. All container can be found [here on GitHub](https://github.com/anabeloff/docker_images).

In general there are two types of BASH scripts here. "OnInstance" scripts initiate an instance and run script which initiates Docker container. "InContainer" scripts designed to run inside Docker container and included in the image. What means, if you change "InContainer" script you need to rebuild a Docker image.

Part 0: Docker images and AWS instances
---------------------------------------

Here is a quick introduction into building Docker container from image and AWS cloud.
If you don't have images in Docker on your machine, go to [GitHub repository](https://github.com/anabeloff/docker_images) and download folder you need. Then `cd` inside required directory on your machine. There you can find multiple files or directories, but often it's just one, called `Dockerfile`.
Run following command inside filder to compile the container called 'rrnaseq':

### Build Docker image

``` bash
docker build -t rrnaseq .
```

Image compilation may take some time.
If you planning to run Docker on AWS platform use ECR service to store Docker images. Each repository in ECR has a button 'push commands', which will show instructions to push container from local machine to ECR repository.
In this case there will be 4 commands:

``` bash
docker build -t rrnaseq .

# Tag container with link ID of disignated repository on ECR
docker tag rrnaseq:latest 123456789.dkr.ecr.ca-central-1.amazonaws.com/rrnaseq:latest

# Login to ECR
$(aws ecr get-login --no-include-email --region ca-central-1)

# Push image to ECR
docker push 123456789.dkr.ecr.ca-central-1.amazonaws.com/rrnaseq:latest
```

### AWS OnInstance tamplate

Basic script tamplate to run on AWS instance.

``` bash
UDATA="$( cat <<EOF
#!/bin/bash
 ## Important system variables

   
    # System image
    # Amazon Linux version from 2018
    # with pre installed Docker
    AMI_IMAGE="ami-0d4c310a3ab39a06b"
    
    # Memory optimised instance
    # CPU 4
    # ECU 19
    # RAM 32Gb
    # SSD 150Gb
    # PRICE 0.288
    INSTANCE_TYPE="r5d.xlarge"
    THREADS=4

  # Insert BASH script here.

EOF
)"
 
 
# Run instance command
aws ec2 run-instances \
--image-id $AMI_IMAGE \
--iam-instance-profile Name="UltimateRole" \
--security-group-ids yourEnv \
--count 1 \
--instance-initiated-shutdown-behavior terminate \
--user-data "$UDATA" \
--instance-type $INSTANCE_TYPE \
--key-name awsKey \
--query 'Instances[0].InstanceId'
```

AWS `run-instances` command includes option `--user-data` which allows to supply a script which going to be run after instance is initiated. In case of provided example above we put script into `$UDATA` variable using `EOF` trick. Othrwise you can save script into a file and put a path in `--user-data` option.

Options `--security-group-ids` and `--key-name` you have to figure out yourself following AWS manual.

Option `--image-id` specifies the OS image. I generally reconmmend using Amazon Linux if you going to run Docker. In example is a private image of Amazon Linux with pre-installed and updated Docker.

`--instance-type` To run efficient analysis with large files like NGS data choose instances with SSD drive. On these instances, **REMEMBER** all data on SSD will be lost upon shutdown. Data on system drive will remain intact if instance was stopped.

When running `aws` command on newly created instance you always have to provide credentials to access data in your account. To avoid doing it every time on each instance create a Role with rights to use specific or all AWS services. Then you can specify this Role for newly created instance with option `--iam-instance-profile Name="UltimateRole"`.

Finally, `--instance-initiated-shutdown-behavior` option is here to specify behavior on shutdown. Default is 'stop', what means instance can be restarted in the future. But if you want to use instance only once, then provide 'terminate' option. Just remember, when you using instance with SSD drive all data on it will be lost upon shutdown even if the instance was just 'stopped', not 'terminated'. Data on system drive will remain intact if instance was stopped. Termination will remove all traces of instance exsistance.

### Docker containers

All Docker containers used in this project can be found in [GitHub repository](https://github.com/anabeloff/docker_images).

Part 1: Quality control and trimming
------------------------------------

Initial step of every NGS project is a quality check. In this project we going to analyse initial FASTQ files and alignment BAM quality.
This section is a first step of the analysis and concentrated on FASTQ files.

Usual procedure with unknown files is to run quality check -&gt; trimm -&gt; run quality check again. This is an interactive procedure and doesn't fit as part of a longer pipeline. Quality control and trimming is done here by three tools:

-   [FastQC](http://www.bioinformatics.babraham.ac.uk/projects/fastqc).
-   QualiMap2 (Okonechnikov, Conesa, and García-Alcalde 2015)
-   Trimmomatic v0.36 (Bolger, Lohse, and Usadel 2014)

All these tools are part of Docker container *qualimapUbuntu14*.
To run either of these tools you need to specify enviroment variables to the container. But first, if run is going to happen on AWS platform you need perform following steps (see example script 'OnInstance\_quali.sh'):

1.  Prepare SSD drive.
2.  Upload data to SSD from S3.
3.  Run Docker container on SSD.
4.  Upload results back to S3.

For steps 1,2 and 4 you need to specify variables with paths to S3 buckets and working directories (see 'OnInstance\_quali.sh' for details).

For step 3, the container on start initiates the script, which reqires certain variables for proper run (see 'InContainer\_quali.sh' for details). But in general there is one main variable `ANALYSIS`. It has three options "qualimap", "trimm" and "fastqc".

To run initial quality check with FastQC specify `ANALYSIS="fastqc"` and make sure files in the working directory.

**FASTQ files NOTE**: 'InContainer\_quali.sh' script is looking for files with **.fastq.gz** extention and names must contain **\_R1** or **\_R2** for paired reads.

As in this project quality of sequencing data was not too good, thus files reqired some trimming. First we specify `ANALYSIS="trimm"` and additional options for Trimmomatic. Here is an example used in this project:

    CROP_LEN=60
    MIN_LEN=36
    HEADCROP=9

If quality is satisfactory we can move to a next step.

Part 2: Alignment and quality check
-----------------------------------

This part includes two steps: reference based alignment of RNA-seq data with STAR aligner (Dobin et al. 2013) and output BAM quality check.

*rnaseqpipe* container runs 'InContainer\_star.sh' script which looking for **.fastq** files, with names containing **\_R1** or **\_R2**. Make sure to download right type of files from S3 bucket specified in 'OnInstance\_star.sh'.

'OnInstance\_star.sh' script for *rnaseqpipe* reuires to specify following variable for Docker container:

`PREFIX_STAR` - specifies file name prefix for STAR output files.
`THREADS` - number of CPUs.

When BAM file is saved we can use Qualimap2 to assess the quality. The important feature of QualiMap2 is that it allows to perform 3'-5' Bias assessment on BAMs. To utilise this feature QualiMap2 requires GTF file supplied for RNA-seq data. For other types of analysis it's GFF. Here we use *qualimapUbuntu14* container and scripts from previous part with `ANALYSIS="qualimap"`.

Now 'OnInstance\_quali.sh' will require additional variables:

`GTFFILE` - path to GTF file on container's working drive.

In addition `PROJECT_DIR` variable should be directed to STAR output directory in S3 repository.

Part 3: Creating Summarized Experiment for DESeq2 analysis
----------------------------------------------------------

Creating Summarized Experiment (SE) is the first step in running RNA-seq analysis in R. It separated from other R scripts as this step is computationslly heavy and it's better be run on large AWS instance or HPC environment.

In this step we take BAM files for all samples in analysis, combine it with GFF data to produce single R S4 object that going to in the center of futher pipeline. Similarly to previous parts pipeline is made of two scripts.

> OnInstance\_SEobject.sh Starts instance and pulls Docker container -&gt; OnContainer\_SEobject.R creates a SEobjest and saves it to RData file.

The 'OnContainer\_SEobject.R' script is based on instructions for DESeq2 analysis. See [SummarizedExperiment input](http://bioconductor.org/packages/devel/bioc/vignettes/DESeq2/inst/doc/DESeq2.html#summarizedexperiment-input).
For more details on how to create SummurizedExperiment data container for DESeq2 see [Preparing count matrices](http://master.bioconductor.org/packages/release/workflows/vignettes/rnaseqGene/inst/doc/rnaseqGene.html#preparing-count-matrices).

To run this pipeline you need to download all BAM files and GFF annotation in working directory.
Following variables are reqired by Docker container and must be specified in OnInstance script:

`GFFFILE` - path to GFF file in container.
`SPECIES_NAME` - Character string specifying species names.
`SE_NAME` - Output file name for SE object.

Following variables are required only for OnInstance script:

`PROJECT_DIR` - path to BAM files on S3 repository.
`INDEX_GFF` - path to GFF file on S3 repository.

**IMPORTANT NOTE** Specific to *Synchytrium endobioticum* project GFF file.
'OnContainer\_SEobject.R' contains a step to fix problems specific for *Synchytrium* GFF file.

The code below removes all annotation from 9th column of GFF file leaving only 'ID'. As practice showed function 'makeTxDbFromGFF' used to process annotation preferes to use 'Name' annotation from GFF. At the same time, genes that have no 'Name' but only 'ID' will be removed. The main idea of this step is to make sure that all genes have one single type of annotation. This problem applies to many GFF files and not specific to *Synchytrium*.

``` r
GFF <- data.frame(read.delim(GFFFILE, header=F, comment.char="#", quote="", sep="\t"))
GFF$V9 <- gsub("(\\ID=)([^|]*);\\Name=([^|]*)", "\\1\\2", GFF[,9])
```

The following problen is specific for *Synchytrium* GFF file. Sequences in GFF file can be assigned to "+" or "-" DNA strand. Hovewer, start- and stop-codon annotations in *Synchytrium* GFF were only assigned to "+" strand even if associated gene and exons are on "-" strand. That created a warning and all genes and trascripts annotated on "-" strand were automatically removed. To avoid it remove start- and stop-codon annotations from the GFF. Those won't be needed in following analysis.

``` r
GFF<- GFF[GFF$V3 != "start_codon",]
GFF<- GFF[GFF$V3 != "stop_codon",]
```

References
----------

Bolger, Anthony M, Marc Lohse, and Bjoern Usadel. 2014. “Trimmomatic: A Flexible Trimmer for Illumina Sequence Data.” *Bioinformatics* 30 (15). Oxford University Press: 2114–20.

Dobin, Alexander, Carrie A Davis, Felix Schlesinger, Jorg Drenkow, Chris Zaleski, Sonali Jha, Philippe Batut, Mark Chaisson, and Thomas R Gingeras. 2013. “STAR: Ultrafast Universal Rna-Seq Aligner.” *Bioinformatics* 29 (1). Oxford University Press: 15–21.

Okonechnikov, Konstantin, Ana Conesa, and Fernando García-Alcalde. 2015. “Qualimap 2: Advanced Multi-Sample Quality Control for High-Throughput Sequencing Data.” *Bioinformatics* 32 (2). Oxford University Press: 292–94.