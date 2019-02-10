#!/bin/bash

###########################
### QUALIMAP conatainer ###
###########################

# Analysis types

# Qualimap 2
# on BAM files after alignment
# Requires GTF file.
#ANALYSIS="qualimap"

#   Data for No1
#   PROJECT_DIR="s3://aafcdata/no1_Susceptible_tuber_vs_no_tuber_control/star_out/"
#   Data for No2
#   PROJECT_DIR="s3://aafcdata/no2_Susceptible_tuber_vs_resistant_tuber/star_out/"
#   Data for No3
#   PROJECT_DIR="s3://aafcdata/no3_Pathotype_6vs8/star_out/"


# Trimming of raw reads.
# Automatically run FastQC after trimming.
ANALYSIS="trimm"
PROJECT_DIR="s3://aafcdata/no2_Susceptible_tuber_vs_resistant_tuber/raw_data/"
OUT_DIR="s3://aafcdata/no2_Susceptible_tuber_vs_resistant_tuber/trimmed/"

# FastQC run
ANALYSIS="fastqc"
#PROJECT_DIR="s3://aafcdata/no2_Susceptible_tuber_vs_resistant_tuber/"

# Trimmomatic options
CROP_LEN=60
MIN_LEN=36
THREADS=4
HEADCROP=9
# Anotation
# GTF is mandatory for rnaseq.
# GFF can be used for other analyses.
    GTFFILE=/usr/local/src/rnaSeq/workingdrive/gencode.v29.annotation.gtf
    INDEX_GTF=s3://hsgenome/index/gencode.v29.annotation.gtf
# Prepare working drive

                     MOUNT_DIR="/mnt/workingdrive"

                     sudo mkdir $MOUNT_DIR
                     sudo mkfs.ext4 /dev/nvme1n1
                     sudo mount /dev/nvme1n1 $MOUNT_DIR
                     sudo chmod a+w $MOUNT_DIR
                     cd $MOUNT_DIR
# Sync S3 data
                     aws s3 cp $PROJECT_DIR $MOUNT_DIR \
                     --recursive \
                     --exclude "*" \
                     --include "*.bam" \
                     --include "*.gtf"
                     --include "*.fastq.gz"

                    # Pulling image
                    $(aws ecr get-login --no-include-email --region ca-central-1)

                    docker pull 123456789.dkr.ecr.ca-central-1.amazonaws.com/qualimapUbuntu14:latest

# RUN docker container
                    docker run \
                    -e THREADS=$THREADS \
                    -e CROP_LEN=$CROP_LEN \
                    -e MIN_LEN=$MIN_LEN \
                    -e HEADCROP=$HEADCROP \
                    -e GTFFILE=$GTFFILE \
                    -e ANALYSIS=$ANALYSIS \
                    --mount type=bind,source=$MOUNT_DIR,target=/usr/local/src/rnaSeq/workingdrive \
                    766815054095.dkr.ecr.ca-central-1.amazonaws.com/qualim

                    # Sync raw data and indexes

                    echo "Synking data!\n";
            if [ $ANALYSIS = "qualimap" ]
            then

                aws s3 sync $MOUNT_DIR $PROJECT_DIR

            elif [ $ANALYSIS = "trimm" ]
            then

                aws s3 cp $MOUNT_DIR"/trimmed/" $OUT_DIR --recursive --exclude "*" --include "*fastq*"
            fi
#                   sudo shutdown -h now

