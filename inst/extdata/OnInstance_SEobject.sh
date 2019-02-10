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
    #INSTANCE_TYPE="r5d.xlarge"
    #THREADS=4

    # Compute optimised instance
    # CPU 4
    # ECU 17
    # RAM 8Gb
    # SSD 100Gb
    # PRICE 0.192
    #INSTANCE_TYPE="c5d.xlarge"
    #THREADS=4

    # Compute optimised instance
    # CPU 2
    # ECU 9
    # RAM 4Gb
    # SSD 50Gb
    # PRICE 0.096
    INSTANCE_TYPE="c5d.large"
    THREADS=2

###########################
### SE object container ###
###########################

# Data for No1
#    PROJECT_DIR="s3://aafcdata/no1_Susceptible_tuber_vs_no_tuber_control/star_out/"
# Data for No2
    PROJECT_DIR="s3://aafcdata/no2_Susceptible_tuber_vs_resistant_tuber/star_out/"
# Data for No3
#    PROJECT_DIR="s3://aafcdata/no3_Pathotype_6vs8/star_out/"


# Working Directories
# Anotation
# GTF is mandatory for rnaseq.
# GFF can be used for other analyses.
    GFFFILE="/usr/local/src/rnaSeq/workingdrive/Se_LEV6574.gff"
    INDEX_GFF="s3://aafcdata/LEV6574_reference/Se_LEV6574.gff"
    SPECIES_NAME="Synchytrium endobioticum"
# Working Directories
    MOUNT_DIR="/mnt/workingdrive"

# SE object name
    SE_NAME="no2_SEgene_ALL.RData"


UDATA="$( cat <<EOF
#!/bin/bash

    # Download from S3


                    mkdir $MOUNT_DIR
                    sudo mkfs.ext4 /dev/nvme1n1
                    sudo mount /dev/nvme1n1 $MOUNT_DIR
                    sudo chmod a+w $MOUNT_DIR
                    cd $MOUNT_DIR

                    # Sync S3 data
                    aws s3 cp $PROJECT_DIR $MOUNT_DIR \
                    --recursive \
                    --exclude "*" \
                    --include "*.bam"
#                    --include "*S[1-9]A*.bam" --include "*S[1][0-5]A*.bam"
#                    --include "*S[789]A*.bam" --include "*S[1][0-5]A*.bam"
#                    --include "*S[456789]A*.bam" --include "*S[1][345]A*.bam"
#                    --include "*S[1-9]A*.bam"
#                    --include "*S[123789]A*.bam" --include "*S[1][012]A*.bam"
                    aws s3 cp $INDEX_GFF $MOUNT_DIR

                    # Pulling image
                    $(aws ecr get-login --no-include-email --region ca-central-1)

                    docker pull 766815054095.dkr.ecr.ca-central-1.amazonaws.com/rrnaseq:latest

                    # RUN docker container
                    docker run \
                    -e GFFFILE=$GFFFILE \
                    -e SE_NAME=$SE_NAME \
                    -e SPECIES_NAME="$SPECIES_NAME" \
                    --mount type=bind,source=$MOUNT_DIR,target=/usr/local/src/rnaSeq/workingdrive \
                    123456789.dkr.ecr.ca-central-1.amazonaws.com/rrnaseq

                    # Sync raw data and indexes

                    echo "Synking data!\n";

                    rm *.gff

                    aws s3 cp $MOUNT_DIR/$SE_NAME $PROJECT_DIR

                    sudo shutdown -h now

EOF
)"

                        aws ec2 run-instances \
                        --image-id $AMI_IMAGE \
                        --iam-instance-profile Name="robotrole" \
                        --security-group-ids awsEnvTest \
                        --count 1 \
                        --instance-initiated-shutdown-behavior terminate \
                        --user-data "$UDATA" \
                        --instance-type $INSTANCE_TYPE \
                        --key-name awsKey \
                        --query 'Instances[0].InstanceId'
