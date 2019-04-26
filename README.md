# RNAseqFungi

R package to perform RNA-seq analysis with fungal data using DESeq2.  
See R [Manual](https://github.com/anabeloff/RNAseqFungi/blob/master/RNAseqFungi_manual.md) Part 4 for details on usage. 

Package developed by Anatoly Belov for Dr. H. Nguyen lab under the project "Transcriptome analysis of zoospores development in *Synchytrium endobioticum*".


## Basic usage

The usage of the package starts after when SummarisedExperiment (SE) object is created. The package contains example SE objects to use in a test run. To see instructions on how to create SE for `RNAseqFungi` see manual.  


### Step 1: Loading SE object  

``` r
se <- readRDS(system.file("extdata", "SEgene.RData", package = "RNAseqFungi"))

```

### Step 2: creating meta data table.

When creating metadata table it is important to remember the following:  

- Row names of the metadata table should be the same as sample names in the columns of 'SE' object.
- **IMPORTANT!** Make sure to check row names asigned to a correct annotation columns.

For `RNAseqFungi` package following column names **MUST** be included in metadata table:  

- "strains": Types of strains of individual sample names.
- "condition": identifying Control and Test samples.
- "clustering": similar to "condition", this column specifies control and test conditions, only here **MUST** be used only two "control" and "experiment". This part of the table is used by clustering function.

``` r
mtdata <- data.frame(
  strains = factor(c(rep("RussetBurbank", 6), rep("PinkPearl", 3), rep("NoTuberMedia", 2))),
  condition = factor(c( rep("Control", 3), rep("Tuber", 6), rep("Control", 2)), levels = c("Control", "Tuber")),
  resistance = factor(c(rep("Susceptible", 6), rep("Resistant", 3), rep("Control", 2))),
  clustering = factor(c(rep("control", 3), rep("experiment", 6), rep("control", 2)))
)
row.names(mtdata) <- colnames(seDay10cont)

```
### Step 3: creating dds object.

Next use `DDSdataDESeq2` function to create a `DESeq2` container `dds`.  
This function is a basic wrapper for standard `DESeq2` protocol. It includes following steps:  

- Assign metadata to 'SE' object.
- Uses `DESeqDataSet` and `DESeq` functions to create `dds` according to provided formula.
- Filters out sequences with less than 10 reads.

``` r
dds <- DDSdataDESeq2(objectSE = seDay10cont, metaDataTable = mtdata, designFormula = ~ condition)
dds$condition <- stats::relevel(ddsDay2$condition, ref = "Control")

resShrink <- lfcShrink(ddsDay2, coef = resultsNames(ddsDay2)[2], type = "apeglm")
res <- results(ddsDay2, tidy = F)

```

Further functionality of `RNAseqFungi` includes Hierarchical clustering analysis using `clusterGenes` function (see manual Part 4 for more details). `clusterGenes` function outputs dataframe with clustering results and plot using `pheatmap` package. 

Also, package includes several general usage functions to work with standard data formats. For example, manual includes instrustions to assign annotation from BLAST to a specific gene IDs from GFF file. Resulting annotation table then can be provided as an option to `clusterGenes` function.  


For more information see [Detailed manual](https://github.com/anabeloff/RNAseqFungi/blob/master/RNAseqFungi_manual.md).

