## Add packages used in Rmd files

pkgs <- c(
  'remotes',
  'devtools',
  'tidyverse',
  'latex2exp',
  'plotly',
  'rmarkdown',
  'knitr',
  'car',
  'multcomp',
  'gridExtra',
  'ExploreModelMatrix',
  'plot3D',
  'ggplot2',
  'MASS',
  'BiocManager',
  'SummarizedExperiment',
  'parathyroidSE',
  'edgeR',
  'limma',
  'DESeq2',
  'scales',
  'QFeatures',
  'msqrob2')

install.packages("BiocManager", Ncpus = 2L)
BiocManager::install(pkgs)