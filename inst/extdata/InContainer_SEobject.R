#############################################
#Creating data table with summarizedOverlaps#
#############################################

#setwd("/usr/local/src/rnaSeq/workingdrive/DESeq2_analysis")

library("Rsamtools")
library("GenomicFeatures")
library("GenomicAlignments")

SE_NAME <- Sys.getenv("SE_NAME")
GFFFILE <- Sys.getenv("GFFFILE")
SPECIES_NAME <- Sys.getenv("SPECIES_NAME")

#filenames <-list.files(".", recursive=TRUE, pattern="*bam$", full=TRUE)
filenames <-list.files(".", recursive=TRUE, pattern=".bam$", full=TRUE)
bamfiles <- BamFileList(filenames, yieldSize=200000)


#Read annotation file
GFF <- data.frame(read.delim(GFFFILE, header=F, comment.char="#", quote="", sep="\t"))
GFF$V9 <- gsub("(\\ID=)([^|]*);\\Name=([^|]*)", "\\1\\2", GFF[,9])

GFF<- GFF[GFF$V3 != "start_codon",]
GFF<- GFF[GFF$V3 != "stop_codon",]

Format <- "gff3"


write.table(GFF, file="tmp.gff", sep="\t", quote=F, row.names=F, col.names=F, append = F)

transdb<-makeTxDbFromGFF("tmp.gff", format = Format, organism = SPECIES_NAME)
file.remove("tmp.gff")

# This one for CUFFLINKS gtf
#genes <- transcriptsBy(transdb)

# This one for JGI gff
genes <- exonsBy(transdb, by = "gene")
#genes <- exonsBy(transdb, by = "tx")

print("Making Summarized Experiment Object...")

se <- summarizeOverlaps(features=genes, reads=bamfiles,
                        mode="Union",
                        singleEnd=FALSE,
                        ignore.strand=TRUE,
                        fragments=TRUE )


saveRDS(se, file = SE_NAME)
print("SE object saved.")

q(save="no")

