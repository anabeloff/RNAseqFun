

#################################
### Clustering of DESeq2 data ###
#################################



clusterGenes <- function(value = 0,
                         pvalue = 0.1,
                          clusterColumns = NA,
                          summarise_clusters = FALSE,
                          cutTree = NA,
                          distRows = "euclidean",
                          clusterMethod = "average",
                          clusterNames = NULL,
                          annotationTbl = NA,
                          dds = NA,
                          titleExperiment = NA,
                          shrinkLFC = FALSE,
                          test = FALSE) {


  # Default Cluster Names
  if(is.null(clusterNames)) {
    clusterNames <- paste(rep("Cluster", cutTree), c(1:cutTree), sep = "")
  }


  # Default Experiment name
  if(is.na(titleExperiment)) {
    titleExperiment <- base::deparse(base::substitute(dds))
  }
  mainTitle <- paste("Clustering of ", titleExperiment, " Groups: ", cutTree, ".", sep = "")


message("Selecting genes...", appendLF = T)

  # Select data Table

  expressionData <- exprData(value = value, pvalue = pvalue, ds = dds, shrinkLFC = shrinkLFC)
  htmdt <- expressionData[[1]]
  res <- expressionData[[2]]

  #### htmdt selection loop is done
message("done", appendLF = T)

  ## Clustering

  if(is.na(clusterColumns)) {
    coldt <- SummarizedExperiment::colData(dds)
    clusterColumns <- base::row.names(coldt[coldt$clustering == "experiment",])
  }

  dst <- dist(htmdt[,clusterColumns], method = distRows)
  clusters <- hclust(dst, method = clusterMethod)
  clusterCut <- cutree(clusters, cutTree)

  if(test == TRUE) {
    # This part designed to show clustered tree only.
    # Tree is build using the same parameters as in heatmap.
    # It is useful when you need to visualise the tree alone and deside about number of clusters.

    plot(clusters)
    rect.hclust(clusters, k = cutTree, border="blue")
    stop("Choose clusters", call. = FALSE)

  }


message("Creating pheatmap...", appendLF = T)


          ## Heatmap function

          # Annotation for row Clusters
          annot_row <- data.frame(Clusters = factor(clusterCut))
          for(u in c(1:cutTree)) {
            annot_row$Clusters <- sub(paste("^", u, "$", sep = ""), clusterNames[u], annot_row$Clusters)
          }

          # Manual colors for heatmap annotation
          annot <- base::data.frame(SummarizedExperiment::colData(dds))

          #str = RColorBrewer::brewer.pal(n = length(unique(annot$strains)), name ="Greys")
          str = colorRampPalette(brewer.pal(n = 9, name ="Greys"))(length(unique(annot$strains)))
          names(str) <- levels(annot$strains)
          clCut = colorRampPalette(brewer.pal(n = 12, name ="Paired"))(cutTree)
          names(clCut) <- clusterNames
          cond = c("azure3", "azure4")
          names(cond) <- levels(annot$clustering)

          annot_clr <- list(clustering = cond, strains = str, Clusters = clCut)


          # Clusters Summary
          if(summarise_clusters == T) {
            #annot <- annot[annot$clustering == "experiment",]
            annot <- annot[clusterColumns,]

                    main_mt <- data.frame(htmdt[,c(clusterColumns, "Mean")])
                    main_mt$groups <- clusterCut[match(base::row.names(htmdt), names(clusterCut))]
                    for(o in c(1:cutTree)) {
                      main_mt$groups <- gsub(paste("^", o, "$", sep = ""), clusterNames[o], main_mt$groups)
                    }

                    main_mt <- main_mt %>%
                      dplyr::group_by(groups) %>%
                      dplyr::summarise_all(list(mean))

                    rownames(main_mt) <- main_mt$groups


                    annot_row <- data.frame(Clusters = factor(main_mt$groups))
                    base::row.names(annot_row) <- annot_row$Clusters
                    main_mt <- as.matrix(main_mt[,-1])
                    dimnames(main_mt) <- list(annot_row$Clusters, c(base::row.names(annot), "Mean"))

                    main_mt <- main_mt[order(rowMeans(main_mt), decreasing = T),]
                    Variance = round(apply(main_mt, 1, var), digits = 3)
                    main_mt <- cbind(main_mt,Variance)

                    clusters <- F
                    display_numbers <- TRUE

          } else {
                    main_mt <- htmdt[,c(clusterColumns, "Mean")]
                    display_numbers <- FALSE
          }

          # Heat map colors
          minV <- round(min(main_mt))-1
          maxV <- round(max(main_mt))+1
          clr = c(colorRampPalette(rev(brewer.pal(n = 3, name ="PuBu")))(abs(minV)),colorRampPalette(brewer.pal(n = 9, name ="OrRd"))(maxV))

          pheatmap(main_mt, show_rownames = F, show_colnames = F, cluster_cols= FALSE, annotation_col = annot[,c("clustering", "strains")], main = mainTitle, border_color = NA,
                   color = clr,
                   breaks = c(minV:-1, 0, 1:maxV),
                   annotation_row = annot_row,
                   annotation_colors = annot_clr,
                   display_numbers = display_numbers, fontsize_number = 10, number_color = "dodgerblue4",
                   cluster_rows = clusters, cutree_rows = cutTree, treeheight_row = 80,
                   cellwidth = 40)

message("done", appendLF = T)



  ressig <- data.frame(htmdt[,c(clusterColumns, "Mean")])

  # Cluster names
  ressig$groups <- clusterCut[match(base::row.names(ressig), names(clusterCut))]

  for(o in c(1:cutTree)) {
    ressig$groups <- gsub(paste("^", o, "$", sep = ""), clusterNames[o], ressig$groups)
  }


  res <- base::as.data.frame(res)
  res$gene_id <- base::row.names(res)
  ressig$gene_id <- base::row.names(ressig)
  ressig <- dplyr::left_join(ressig, res, by = "gene_id")

  # Annotation table join
  if(!is.na(annotationTbl)) {
    colnames(annotationTbl)[1] <- "gene_id"
    ressig <- dplyr::left_join(ressig, annotationTbl, by = "gene_id")
  }

  return(ressig)
}
