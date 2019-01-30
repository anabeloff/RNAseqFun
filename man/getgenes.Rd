\name{getgenes}
\alias{getgenes}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Extract sequences from genome
}
\description{
Function allow to extract genomic regions specified in GFF file from full lenght fasta genome.
}
\usage{
getgenes(flname = NULL,
          genomeDt = NA,
          geneNamesData = NA,
          gff = NA)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{flname}{
Path and file name. If specified function will output file in FASTA format.
}
  \item{genomeDt}{
DNAStringSet object with genome sequences to extract from.
}
  \item{geneNamesData}{
Character vector corresponding to row names in GFF data.frame. If specified functions will ouput only specified sequences.
}
  \item{gff}{
Data frame. Preferabley output of parseGFF function. If using 'geneNamesData' option row names must contain IDs for specified annotation.
}
}
\details{
%%  ~~ If necessary, more details than the description above ~~
}
\value{
%%  ~Describe the value returned
%%  If it is a LIST, use
%%  \item{comp1 }{Description of 'comp1'}
%%  \item{comp2 }{Description of 'comp2'}
%% ...
}
\references{
%% ~put references to the literature/web site here ~
}
\author{
%%  ~~who you are~~
}
\note{
%%  ~~further notes~~
}

%% ~Make other sections like Warning with \section{Warning }{....} ~

\seealso{
%% ~~objects to See Also as \code{\link{help}}, ~~~
}
\examples{
##---- Should be DIRECTLY executable !! ----
##-- ==>  Define data, use random,
##--	or do  help(data=index)  for the standard data sets.

## The function is currently defined as
function (flname = NA, genomeDt, geneNamesData, gff)
{
    geneNamesData <- as.data.frame(geneNamesData[, 1])
    names(geneNamesData)[1] <- "gene_id"
    het_coor <- left_join(geneNamesData, gff[c("gene_id", "V1",
        "V4", "V5")], by = "gene_id")
    het_coor <- het_coor[!is.na(het_coor$V1), ]
    het_coor$V1 <- as.character(het_coor$V1)
    file.remove(flname)
    message("File removed.")
    for (i in het_coor$gene_id) {
        promoters_seq <- DNAStringSet(genomeDt[[het_coor[het_coor$gene_id ==
            i, "V1"]]], start = het_coor[het_coor$gene_id ==
            i, "V4"], end = het_coor[het_coor$gene_id == i, "V5"])
        names(promoters_seq) <- het_coor[het_coor$gene_id ==
            i, "gene_id"]
        writeXStringSet(promoters_seq, filepath = flname, format = "fasta",
            append = T)
    }
    message("File saved.")
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }% use one of  RShowDoc("KEYWORDS")
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
