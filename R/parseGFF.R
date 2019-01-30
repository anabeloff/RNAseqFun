# Parse GFF
parseGFF <- function(gff = NA,
                     field = NA) {

  if(is.na(gff)) {
    stop("Path to GFF file is not specified!")
  }

  gffdata <- read.delim(gff,
                        header=F,
                        comment.char="#",
                        na.strings = c("","NA"),
                        colClasses=c("character", "character", "character", "integer",  "integer", "character", "character", "character", "character"))
  colnames(gffdata) <- c("sequence", "source", "feature", "start", "end", "score", "strand", "phase", "attr")
  attr <- strsplit(gffdata$attr, split = ';', fixed=T)

  # Check format of the GFF file.
  # If there is "=" in the 9th column that indicates GFF3 format.
  # Otherwise function will use " " to split character string, assuming it is GTF format.
  formatChar = length(grep("=", gffdata[,c("attr")])) > 1

  if(formatChar) {
    splitChar = c("=")
  } else {
    splitChar = c(" ")
  }

        if(!is.na(field)) {
          for (i in field) {

            cl <- sapply(attr, function(atts) {
              a = strsplit(atts, split = splitChar, fixed = F)
              m = match(i, sapply(a, "[", 1))
              if (!is.na(m)) {
                rv = a[[m]][2]
              }
              else {
                rv = as.character(NA)
              }
              return(rv)
            })
            gffdata[i] <- cl
          }
        }


  return(gffdata)
}
