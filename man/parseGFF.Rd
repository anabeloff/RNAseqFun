\name{parseGFF}
\alias{parseGFF}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Parse GFF file format
}
\description{
Function allows to read GFF files into convinient dataframe format. It automatically detects GFF3 or GTF formats.
}
\usage{
parseGFF(gff = NA,
         field = NA)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{gff}{
Character string. Path to GFF file.
}
  \item{field}{
Character string vector of names for attributes in the 9th column of GFF file. If specified, additional columns with attributes names will created.
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
## Read GFF3
GFF <- parseGFF(gff = system.file("extdata", "Se_LEV6574.gff", package = "RNAseqFungi"),
                field = c("ID", "Name"))
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }% use one of  RShowDoc("KEYWORDS")
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
