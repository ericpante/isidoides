library(ape)
setwd("/Users/epante/ownCloud/Xu_etal_2026_Isidoididae/PCI_Zoology/biblio/Lahteenaro_etal_2023_sp_delim_SODA/MSA_stylops")
list.files() -> files
dist.sep=NULL
for (i in files){
	dim(read.dna(i, format="fasta"))[1] -> n.seq
	dist.sep = c(dist.sep, n.seq)
}