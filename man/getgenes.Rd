\name{getGenes}
\alias{getGenes}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Extract genes from genome
}
\description{
Using parseGFF function create a column in GFF data frame that corresponds to feature of interest (gene) names. Then read genome file into DNAStringSet (BioStrings package) object. The function will use sequnce coordinates in GFF to output specifed feature sequence DNAStringSet object.
}
\usage{
getGenes(gff = NA,
        genome = NA, outFile = "sequences.fasta",
        ids_column = NA)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{gff}{
Dara Frame with GFF file data, output of parseGFF function.
}
  \item{genome}{
Genome to extract sequences from. DNAStringSet object from BioStrings.
}
  \item{outFile}{
Name of the output FASTA file.
}
  \item{ids_column}{
Column names in GFF data frame with gene IDs to extract from genome.
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
% R documentation directory (show via RShowDoc("KEYWORDS")):
% \keyword{ ~kwd1 }
% \keyword{ ~kwd2 }
% Use only one keyword per line.
% For non-standard keywords, use \concept instead of \keyword:
% \concept{ ~cpt1 }
% \concept{ ~cpt2 }
% Use only one concept per line.
