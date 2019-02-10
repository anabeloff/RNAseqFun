#!/bin/bash

# Alignment
echo "STAR alignment!"

        if [[ ! -d star_out ]]; then
		        mkdir -p  star_out;
	fi



# Identify R1 and R2 files
for files in *.fastq
do
        if [[ $files == *_R1* ]]; then
                infileR1+=($(ls $files))
		fi

        if [[ $files == *_R2* ]]; then
                infileR2+=($(ls $files))
		fi
done

len=${#infileR1[@]};

for ((i=0;i<$len;i++));
do

outfile="./star_out/"$PREFIX_STAR$i;

                /usr/local/src/rnaSeq/STAR \
                --runThreadN $THREADS \
                --genomeDir /usr/local/src/rnaSeq/workingdrive/indexes \
                --outFileNamePrefix $outfile \
                --outSAMtype BAM SortedByCoordinate \
                --readFilesIn ${infileR1[$i]} ${infileR2[$i]}

done
