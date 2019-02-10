#!/bin/bash

# Trimming

if [ $ANALYSIS = "trimm" ] || [ $ANALYSIS = "fastqc" ]
then



# Identify R1 and R2 files
for files in workingdrive/*.fastq.gz
do
if [[ $files == *R1* ]]; then
R1+=($(ls $files))
fi

if [[ $files == *R2* ]]; then
R2+=($(ls $files))
fi
done

len=${#R1[@]};

  for ((i=0;i<$len;i++));
  do

  infileR1=${R1[$i]}
  infileR2=${R2[$i]}

  outfileR1=${infileR1%%_R1_*}"_R1_paired.fastq";
  outfileR2=${infileR2%%_R2_*}"_R2_paired.fastq";

  outfileR1unpaired=${infileR1%%_R1_*}"_R1_unpaired.fastq";
  outfileR2unpaired=${infileR2%%_R2_*}"_R1_unpaired.fastq";

  if [ $ANALYSIS = "trimm" ]
  then
  echo "Trimming starts!"

  if [[ ! -d workingdrive/trimmed ]]; then
  mkdir -p workingdrive/trimmed;
  fi

  java -jar Trimmomatic-0.36/trimmomatic-0.36.jar PE -threads $THREADS -phred33 $infileR1 $infileR2 $outfileR1 $outfileR1unpaired $outfileR2 $outfileR2unpaired LEADING:6 CROP:$CROP_LEN HEADCROP:$HEADCROP SLIDINGWINDOW:4:15 MINLEN:$MIN_LEN

  /usr/local/src/rnaSeq/FastQC/fastqc $outfileR1
  /usr/local/src/rnaSeq/FastQC/fastqc $outfileR2

  mv workingdrive/*paired* workingdrive/trimmed/

    echo "Trimming complete!"

  elif [ $ANALYSIS = "fastqc" ]
  then
  echo "FastQC starts!"

  /usr/local/src/rnaSeq/FastQC/fastqc $infileR1
  /usr/local/src/rnaSeq/FastQC/fastqc $infileR2

  fi

  done



  elif [ $ANALYSIS = "qualimap2" ]
  then
  echo "QualiMap 2 starts!"

  declare -a bamfiles;

  # List BAM files
  for files in /usr/local/src/rnaSeq/workingdrive/*.bam
  do
  bamfiles+=($(ls $files))
  done


  # QualiMap 2 run
  len=${#bamfiles[@]};

    for ((i=0;i<$len;i++));
    do

    bamfile=${bamfiles[$i]};
    outdir=${bamfile%%Align*}"_BAMqc";

    /usr/local/src/rnaSeq/qualimap_v2.2.1/qualimap rnaseq \
    -bam $bamfile \
    -gtf $GTFFILE \
    -outdir $outdir

    # Packing quality report
    tar -cvzf $outdir.tar.gz $outdir;

    done

    echo "QualiMap 2 run complete!\n"

    fi
