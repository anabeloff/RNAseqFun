getgenes <- function(gff = NA,
                     genome = NA, outFile = "sequences.fasta",
                     ids_column = NA) {

  gffDt <- data.frame(gff[c(ids_column, "sequence", "start", "end", "strand")])

  extracted_seq <- Biostrings::DNAStringSet()

  geneIDs <- gffDt[,ids_column]

        for(i in 1:length(geneIDs)) {

          # condition for positive strand
          #gene_seq <- DNAStringSet(genomeDt[[gffDt[gffDt[,ids_column] == geneIDs[i], "sequence"]]], start = gffDt[gffDt[,ids_column] == geneIDs[i], "start"], end = gffDt[gffDt[,ids_column] == geneIDs[i], "end"])

          # Chromosome name in 'sequence' column
          chr =  as.character(gffDt[gffDt[,ids_column] == geneIDs[i], "sequence"])

          # Gene's position
          start_position = as.integer(gffDt[gffDt[,ids_column] == geneIDs[i], "start"])
          end_position = as.integer(gffDt[gffDt[,ids_column] == geneIDs[i], "end"])


          # Extracted sequence
          gene_seq <- Biostrings::DNAStringSet(Biostrings::subseq(genome[[chr]], start = start_position, end = end_position))
          names(gene_seq) <- geneIDs[i]

          # Strand sign
          stran_check = as.character(gffDt[gffDt[,ids_column] == geneIDs[i], "strand"])

          if(stran_check == "-") {
            # If gene is on negative srtad
            gene_seq <- reverseComplement(gene_seq)
          }

          # Append to final sequence set.
          extracted_seq <- append(extracted_seq, gene_seq, after=length(extracted_seq))
        }

  if(!is.na(outFile)) {
    #Write FASTA file with significant genes.
    writeXStringSet(extracted_seq, filepath = outFile, format="fasta", append = F)
  }

  return(extracted_seq)
}
