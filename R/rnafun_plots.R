#### PCA plot ####
# The function based on plotPCA from DESeq2 package.


rnafun_plotPCA <- function(counts, group_vector, ntop = 500, returnData = FALSE) {

  # calculate row variance
  rv <- rowVars(counts)
  # select the ntop genes by variance
  select <- order(rv, decreasing=TRUE)[seq_len(min(ntop, length(rv)))]
  # subset counts matrix
  counts <- counts[select,]


  # calculate pca
  pca <- prcomp(t(counts))

  # the contribution to the total variance for each component
  percentVar <- pca$sdev^2 / sum( pca$sdev^2 )

  # Plot data frame
  pca_dt <- as.data.frame(pca1$x)
  pca_dt$group <- group_vector


  # plot
  if (returnData) {
    attr(d, "percentVar") <- percentVar[1:2]
    return(d)
  }

  pcapl <- ggplot(data=d, aes_string(x="PC1", y="PC2", color="group")) + geom_point(size=3) +
    xlab(paste0("PC1: ",round(percentVar[1] * 100),"% variance")) +
    ylab(paste0("PC2: ",round(percentVar[2] * 100),"% variance")) +
    coord_fixed()

  return(pcapl)
}



#### BOXPLOT VARIANCE #####

rnafun_boxplot <- function(counts) {

  boxplot(counts, main="", xlab="", ylab="Raw read counts per gene (log10)",axes=FALSE)
  axis(2)
  axis(1,at=c(1:length(colnames(counts))),labels=colnames(counts),las=2,cex.axis=0.8)
}
