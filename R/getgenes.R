getgenes <- function(flname = NULL,
                     genomeDt = NA,
                     geneNamesData = NA,
                     gff = NA) {


  if(is.na(genomeDt)) {
    stop("Genome data is missing!", call. = FALSE)
  } else if(is.na(gff)) {
    stop("GFF data is missing!", call. = FALSE)
  }

  if(!is.na(geneNamesData)) {
    gff <- gff[geneNamesData, c("sequence", "start", "end")]
  }



  # Extract and write fasta file of specified genes.
  # Don't forget to delete

  seqNames <- row.names(gff)

  seqs_out <- DNAStringSet()

  for(i in 1:length(seqNames)) {

    # Genes of interest
    seqs <- DNAStringSet(genomeDt[[gff[seqNames[i], "sequence"]]], start = gff[seqNames[i], "start"], end = gff[seqNames[i], "end"])
    names(seqs) <- seqNames[i]

    seqs_out <- append(seqs_out, seqs, after = length(seqs_out))
  }

  # Write FASTA file.

  if(!is.null(flname)) {
      if(file.exists(flname)) {
        file.remove(flname)
        message("File removed.")
      }
    message("File saved.")
    writeXStringSet(seqs_out, filepath = flname, format = "fasta", append = F)
  }

  return(seqs_out)
}
