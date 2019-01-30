\name{exprData}
\alias{exprData}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Expression matrix
}
\description{
Function extracts assay expression data from DESeq and transfoms it into data matrix. Before trnasforming to matrix it performs normalization relevant to particular experiment setup.
}
\usage{
exprData(dataTable)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{dataTable}{
Normilised experiment data (nt) from DESeq2 or list containing several data tables like 'nt' or 'rld'.
}
 \item{value}{
Default NULL. Filter results by DE value in each column.
}
 \item{notNormRaw}{
Default FALSE. Used in bubble plot function. If TRUE no DE is calculated and no data filtered with 'value' option.
}
}
\details{
This function is specifically designed to work with data from C.parasitica transcriptome expriment. If you wish to use other samples data this function must be reworked.
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
##---- Should be DIRECTLY executable !! ----
##-- ==>  Define data, use random,
##--	or do  help(data=index)  for the standard data sets.

## The function is currently defined as
function (x)
{
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }% use one of  RShowDoc("KEYWORDS")
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
