##############################
##                          ##
## Read BLAST data function ##
##                          ##
##############################
readBLAST <- function(blastFile,
                      bitScore = NA,
                      eValue = NA,
                      annotationTbl = NA) {


  blast.read.data <- read.delim(blastFile,
                                header = F,
                                comment.char = "#",
                                na.strings = c("","NA"),
                                col.names = c("queryID", "gene_id", "identity", "length", "mismatch", "gaps", "start", "end", "gene_id_start", "gene_id_end", "evalue", "Score"),
                                colClasses=c("character", "character", "numeric", "integer",  "integer", "integer", "integer", "integer", "integer", "integer", "numeric", "numeric"))
  #filter blast results
  if(!is.na(bitScore)) {
    blast.read.data <- blast.read.data[blast.read.data$Score >= bitScore,]
  }

  if(!is.na(eValue)) {
    blast.read.data <- blast.read.data[blast.read.data$evalue <= eValue,]
  }

   blast.data <- blast.read.data # %>%
  #   dplyr::group_by(queryID) %>%
  #   dplyr::filter(Score == max(Score) & evalue == min(evalue)) %>%
  #   dplyr::summarise_all(funs(dplyr::first))

  if(!is.na(annotationTbl)) {
    names(annotationTbl)[1] <- "queryID"
    blast.data <- left_join(blast.data, annotationTbl, by = "queryID")
  }
  return(blast.data)
}
