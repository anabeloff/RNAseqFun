##########################
### Create DDS from SE ###
##########################


DDSdataDESeq2 <- function(objectSE = NA,
                          metaDataTable = NA,
                          designFormula = ~ .) {

  colData(objectSE) <- S4Vectors::DataFrame(metaDataTable)
  ddsSE <- DESeq2::DESeqDataSet(objectSE, design = designFormula)
  dds <- DESeq2::DESeq(ddsSE)
  keep <- BiocGenerics::rowSums(counts(dds)) >= 10
  dds <- dds[keep,]

  return(dds)

}
