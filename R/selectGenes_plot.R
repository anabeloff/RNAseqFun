selectGenes_plot <- function(selGenes_tbl = NA,
                             dds = NA) {
  #DOTPLOT
  annot <- data.frame(colData(dds)[, c("strains", "condition")])

  bubble_data <- selGenes_tbl

  bubble_data <- data.frame(t(bubble_data))
  bubble_data <- cbind(annot, bubble_data)
  bdml <- tidyr::gather(bubble_data, "variable", "value", c(3:length(names(bubble_data))))

  dotp <- ggplot(bdml, aes(variable, value)) +
    geom_point(aes(color = condition), shape=20, alpha=0.8, size = 5) +
    scale_colour_manual(values = c("dodgerblue3","chocolate3"), guide=guide_legend(title="Conditions", keyheight=0)) +
    #facet_grid(strains ~.) +
    labs(x = NULL, y = "log2 normalized counts") +
    #theme_light()
    theme(panel.background=element_rect(fill="white"),
          title=element_text(size=14,colour="black"),
          axis.title=element_text(size=14,colour="black"),
          text=element_text(size=14,colour="black"),
          panel.grid.major=element_line(size=0.5,colour="gray80",linetype = "dotted"),
          panel.grid.minor=element_line(size=0.5,colour="gray80",linetype = "dotted"),
          panel.border = element_rect(fill = NA, colour = "#BFBFBF"),
          legend.position="right",
          axis.text.x = element_text(angle = 45, hjust = 1))
  return(dotp)
}
