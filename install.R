## Add packages used in Rmd files
pkgs <- c(
  'rmarkdown','knitr','tidyverse','car','multcomp','gridExtra','ExploreModelMatrix','plot3D','ggplot2','MASS','BiocManager','SummarizedExperiment','parathyroidSE','edgeR','limma','DESeq2','scales')
install.packages(pkgs, Ncpus = 2L)
