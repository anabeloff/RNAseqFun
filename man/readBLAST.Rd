\name{readBLAST}
\alias{readBLAST}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Read BLAST output
}
\description{
Functions reads BLAST tabulated (6) output format files. It outputs data.frame with standard column names. readBLAST also allows to filter by Bit Score or evalue.
}
\usage{
readBLAST(blastFile,
          bitScore = NA,
          eValue = NA,
          annotationTbl = NA)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{blastFile}{
Path to BLAST out put file.
}
  \item{bitScore}{
Numeric. If specified sets a threshold value for BitScore. Only lines above the threshold will be outputted. Default NA.
}
  \item{eValue}{
Numeric. If specified sets a threshold value for e-value. Only lines below the threshold will be outputted. Default NA.
}
  \item{annotationTbl}{
Data frame. If specified joins annotation data frame with BLAST output. It uses the first column of the annotation data frame to join by, so it must contain the same IDs as queryID column of BLAST file.
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
function (x)
{
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }% use one of  RShowDoc("KEYWORDS")
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
