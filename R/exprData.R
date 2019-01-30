

# function to normilise expression data from DESeq2 before plotting.
exprData <- function(value = NULL,
                     ds = NA,
                     logChange = "absolute",
                     shrinkLFC = FALSE,
                     calcDE = TRUE) {
  # Select data Table

  #Extracting assay

  if(is.list(ds)) {
    for (u in 1:length(ds)) {
      nt <- normTransform(ds[[u]])
      tb <- SummarizedExperiment::assay(nt)

      if(u == 1) {
        htmdt <- tb
      } else {
        htmdt <- rbind(htmdt, tb)
      }
    }
  } else {
    nt <- normTransform(ds)
    htmdt <- SummarizedExperiment::assay(nt)
  }


  # Normilising controls

  coldt <- SummarizedExperiment::colData(ds)

  if(isTRUE(calcDE)) {
        controls <- base::row.names(coldt[coldt$clustering == "control",])
        htmdt[,c(controls[1])] <- base::rowMeans(htmdt[,controls])

        #Showing Differential expression in Log2fold change scale for individeal columns.
        experiments <- base::row.names(coldt[coldt$clustering == "experiment",])
        htmdt[,experiments] <- htmdt[,experiments] - htmdt[,c(controls[1])]

        htmdt <- base::cbind(htmdt, base::rowMeans(htmdt[,experiments]))
        colnames(htmdt)[length(colnames(htmdt))] <- "Mean"
  } else {

  }

  #removing inf numbers
  resInf <- results(ds, tidy = T)
  resInf[is.na(resInf$log2FoldChange),] <- 0
  resInf[resInf$log2FoldChange == -Inf,3] <- 0
  resInf[resInf$log2FoldChange == Inf,3] <- 0

  minV <- min(resInf$log2FoldChange)
  message(base::paste("Minimum value is ", minV, sep = ""), appendLF = T)
  maxV <- max(resInf$log2FoldChange)
  message(base::paste("Maximum value is ", maxV, sep = ""), appendLF = T)



  # Shrinkage option
  if(isTRUE(shrinkLFC)) {
    res <- lfcShrink(ds, coef = resultsNames(ds)[2], type = "apeglm")
  } else {
    res <- results(ds)
    res[is.na(res$log2FoldChange), "log2FoldChange"] <- 0
    res[res$log2FoldChange == -Inf,2] <- minV-1
    res[res$log2FoldChange == Inf,2] <- maxV+1
  }



  #Selection for Downregulated, upregulated genes, or both (default).
  #For any other instance it will select by adjusted p-value.
  if(logChange == "absolute") {
    ressig <- res[abs(res$log2FoldChange) >= value,]
  } else if(logChange == "up") {
    ressig <- res[res$log2FoldChange >= value,]
  } else if(logChange == "down") {
    ressig <- res[res$log2FoldChange <= -value,]
  } else if((logChange == "p-value")) {
    ressig <- res[!is.na(res$padj) & res$padj <= value,]
  } else {
    stop("logChange parameter is not correct! \n Use: \n 'absolute' - to sort genes by Log2fold change and include all, down and up regulated genes. \n
        'up' -  to sort genes by Log2fold change and include only Upregulated genes. \n
        'down' - to sort genes by Log2fold change and include only Downregulated genes.\n
        'p-value' - to sort by column 'padj' (adjusted p-value) in DESeq2 data set and include all, down- and upregulated genes.")
  }

  sel <- rownames(ressig[order(ressig$log2FoldChange, decreasing = T),])
  htmdt <- htmdt[sel,]


  htmdt <- base::as.matrix(htmdt)
  #ressig <- base::as.data.frame(ressig)

  finalDT <- list(htmdt, ressig)

  return(finalDT)
}

#a <- exprData(nt, value = 2)
