#!/usr/bin/env Rscript

require(writexl)

arg <- commandArgs(trailingOnly = TRUE)
tsvfile <- arg[1]

df <- read.delim(tsvfile, sep = "\t")
writexl::write_xlsx(df, path = "multiqc_general_stats.xlsx")