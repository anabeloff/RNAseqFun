#########################################################
## Select genes function (by logFold change or p-value ##
#########################################################

selectGenes <- function(pattern = NULL,
                        value = 0,
                        colNames = NA,
                        annotationTbl = NA,
                        dds = NA,
                        inv = FALSE,
                        srinkLFC = FALSE) {

  dt <- exprData(ds = dds, value = 0, calcDE = FALSE, shrinkLFC = srinkLFC)

  htmdt <- dt[[1]]
  res <- dt[[2]]


  if(pattern != "" && pattern != " " && !is.null(pattern)) {


    # PATTERN SEARCH

    # This scripts searches annotation table for matches in specified columns.
    if(is.na(colNames)) {
      colsUsed <- base::colnames(annotationTbl)
    } else {
      colsUsed <- colNames
    }

                      for (i in c(colsUsed)) {
                        prN <- annotationTbl[grep(pattern, annotationTbl[,i], ignore.case = T, invert = inv),]
                        if(i == colsUsed[1]) {
                          mergedList <- prN$gene_id
                        } else {
                          mergedList <- c(mergedList, prN$gene_id)
                        }
                      }

    sel <- unique(as.vector(mergedList))
    out <- data.frame(htmdt)

    out <- out[rownames(htmdt) %in% sel,]

  } else {
    out <- htmdt
  }

  res$gene_id <- row.names(res)

  res <- as.data.frame(res) %>%
    dplyr::filter(abs(log2FoldChange) >= value)

  out <- out[rownames(out) %in% res$gene_id,]
  out <- data.frame(out)


  #Final table

  # # Annotation table join
  # if(!is.na(annotationTbl)) {
  #     out <- dplyr::left_join(res, annotationTbl, by = "gene_id")
  # }
  #
  # row.names(out) <- out[,"gene_id"]

  return(out)
}
