\name{clusterGenes}
\alias{clusterGenes}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
DESeq hierarchical data clustering.
}
\description{
Function accepts list of data frames produced by normTransform() function with DESeq2 dataset.
}
\usage{
clusterGenes(value = 0,
              clusterColumns = NA,
              summarise_clusters = FALSE,
              cutTree = NA,
              distRows = "euclidean",
              clusterMethod = "average",
              clusterNames = NULL,
              annotationTbl = NA,
              dds = NA,
              titleExperiment = NA,
              shrinkLFC = FALSE,
              test = FALSE)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{value}{
Numeric, default 0. Differential expression (DE) cutoff. Number provided in 'value' will be taken as absolute. All genes with DE less than 'value' or more than '-value' will be excluded.
}
  \item{dds}{
DESeq() function output.
}
  \item{clusterColumns}{
Numeric vector. This parameter identifies column numbers (sample names) which will be used in clustering. Default NA.
}
  \item{summarise_clusters}{
Logical, default FALSE. If TRUE function will produce short heatmap. In this version each cluster will be present by single value, produced by taking mean expression in each cluster.
}
  \item{distRows}{
Distance options passed to dist() function. Default "euclidean".
}
  \item{clusterMethod}{
Clustering methods passed to hclust() function. Default "average".
}
  \item{cutTree}{
Number of clusters. Option passed to hclust() function.
}
  \item{clusterNames}{
Character vector of cluster names. Number of names should correspond to number clusters defined by 'cutTree'.
}
  \item{annotationTbl}{
Data frame with annotations for genes in Summarised Experiment data, if available.
}
  \item{titleExperiment}{
Character string. Option allow to add specific terms to plot's title. If NA (default) function will use name of an object used in 'dds' option.
}
  \item{shrinkLFC}{
Logical. If TRUE function will use 'lfcShrink()' function from DESeq2 package to remove variable genes with low counts. For more details see DESeq2 manual.
}
  \item{test}{
Logical. If TRUE function will only output HC tree with highlighted clusters specified by 'cutTree' option.
}
}
\details{
If 'clusterColumns' option is NA (default) function will automatically try to identify columns for clustering. It will 'clustering' column from metadata and clustering will be performed on columns identified as 'experiment'.
</br>
To identify best number of clusters for 'cutTree' option use 'test' option. If 'test' is TRUE function will only output tree with highlighted number of clusters specified in 'cutTree'.
</br>
In this experiment it is recommended to use in house DDSdataDESeq2() function to produce DESeq object for 'dds' option.
}
\value{
Function produces two outputs. 'pheatmap' graph will appear in the plot area and dataframe.
Dataframe will contain data used to create 'pheatmap' combained with results() output from DESeq object.
}
\references{
%% ~put references to the literature/web site here ~
}
\author{
Anatoly Belov
}
\note{
%%  ~~further notes~~
}

%% ~Make other sections like Warning with \section{Warning }{....} ~

\seealso{
%% ~~objects to See Also as \code{\link{help}}, ~~~
}
\examples{

se <- readRDS(system.file("extdata", "no2_SEgene.RData", package = "RNAseqFungi"))

mtdata <- data.frame(
  strains = factor(c(rep("RussetBurbank", 3), rep("PinkPearl", 3), rep("RussetBurbank", 3), rep("PinkPearl", 3), rep("NoTuberMedia", 3))),
  condition = factor(c(rep("Tuber", 12), rep("Control", 3)), levels = c("Control", "Tuber")),
  day = factor(c(rep("Day10", 6), rep("Day2", 9)), levels = c("Day2", "Day10")),
  clustering = factor(c(rep("experiment", 12), rep("control", 3)))
)
row.names(mtdata) <- colnames(se)

dds <- DDSdataDESeq2(objectSE = se, metaDataTable = mtdata, designFormula = ~ day + condition)
dds$condition <- stats::relevel(dds$condition, ref = "Control")

groupsDay2 <- clusterGenes(dds = dds,
                            summarise_clusters = F,
                            value = 1,
                            cutTree = 5)
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ RNA }
\keyword{ RNA-seq }
\keyword{ transcriptome }
\keyword{ NGS }
\keyword{ DESeq2 }
