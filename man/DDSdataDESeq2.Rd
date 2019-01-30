\name{DDSdataDESeq2}
\alias{DDSdataDESeq2}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
DDS from SE
}
\description{
Create data analysis from SummirasedExperiment object for DESeq2.
}
\usage{
DDSdataDESeq2(objectSE = NA,
              metaDataTable = NA,
              designFormula = ~ .)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{objectSE}{
Summirased Experiment object.
}
  \item{metaDataTable}{
Data frame. Meta data for Summirased Experiment object. Make columns as factors.
}
  \item{designFormula}{
Experiment design formula for DESeqDataSet function from DESeq2.
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
