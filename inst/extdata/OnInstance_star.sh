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
    INSTANCE_TYPE="c5d.xlarge"
    THREADS=4

    # Compute optimised instance
    # CPU 2
    # ECU 9
    # RAM 4Gb
    # SSD 50Gb
    # PRICE 0.096
    #INSTANCE_TYPE="c5d.large"
    #THREADS=2



# STAR prefix
PREFIX_STAR="no2_S"


### Sequence files path to S3 storage



# Data for No1

# Data for No2
    PROJECT_DIR="s3://aafcdata/no2_Susceptible_tuber_vs_resistant_tuber/trimmed/"
    OUT_DIR="s3://aafcdata/no2_Susceptible_tuber_vs_resistant_tuber/star_out/"

# Data for No3

# Working Directories
    MOUNT_DIR="/mnt/workingdrive"
    INDEX_FILES=$MOUNT_DIR"/indexes/"

# Instance log file path
    LOGFILE=$MOUNT_DIR"/logs/sample-"$PREFIX_STAR"-ins-"$INSTANCE_TYPE"-cloud-init-output.log"


UDATA="$( cat <<EOF


#!/bin/bash

    # Download from S3


                    mkdir $MOUNT_DIR
                    sudo mkfs.ext4 /dev/nvme1n1
                    sudo mount /dev/nvme1n1 $MOUNT_DIR
                    sudo chmod a+w $MOUNT_DIR
                    cd $MOUNT_DIR


                    # Sync raw data and indexes

                    aws s3 cp $PROJECT_DIR $MOUNT_DIR \
                    --recursive \
                    --exclude "*" \
                    --include "*_paired.fastq"
                    aws s3 sync s3://aafcdata/LEV6574_reference/ $INDEX_FILES

                    # Pulling image
                    $(aws ecr get-login --no-include-email --region ca-central-1)

                    docker pull 123456789.dkr.ecr.ca-central-1.amazonaws.com/rnaseqpipe:latest

                    # RUN docker container
                    docker run \
                    -e THREADS=$THREADS \
                    -e PREFIX_STAR=$PREFIX_STAR \
                    --mount type=bind,source=$MOUNT_DIR,target=/usr/local/src/rnaSeq/workingdrive \
                    123456789.dkr.ecr.ca-central-1.amazonaws.com/rnaseqpipe

                    # Sync raw data and indexes

                    echo "Synking data!\n";


                    # Saving logs
                    mkdir $MOUNT_DIR/logs

                    cp /var/log/cloud-init-output.log $LOGFILE

                    aws s3 sync $MOUNT_DIR"/star_out/" $OUT_DIR

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
