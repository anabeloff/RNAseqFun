\name{selectGenes}
\alias{selectGenes}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Select genes from DESeq
}
\description{
Function allow to filter data from DESEq2 results using keyword search in annotation table.
}
\usage{
selectGenes(pattern = NULL,
                        value = 0,
                        colNames = c("goName", "CP_iprDesc", "Protein.names", "UP_iprDesc", "TrEM_iprDesc"),
                        annotationTbl = NA,
                        dataTable = nt,
                        inv = FALSE)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{pattern}{
Used in grep search within annotation table.
}
  \item{value}{
DE value to filter results.
}
  \item{colNames}{
Character or numeric vector. Column names or numbers in annotation table where pattern is going to be searched.
}
  \item{annotationTbl}{
Data frame. Annotation table. MUST have column 'gene_id' containing same gene IDs as row names of DESeq results table.
}
  \item{dataTable}{
DESeq2 data.
}
  \item{inv}{
Logical. If TRUE function will output rows without specified pattern.
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
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }% use one of  RShowDoc("KEYWORDS")
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
