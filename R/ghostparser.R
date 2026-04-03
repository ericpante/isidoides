# Isidoides, Ghostparser tests
# eric pante, 2026-03-26

# load ghostparser results, ran based on valid_triplets.txt ; the program re-orients triplets.
setwd('~/ownCloud/Xu_etal_2026_Isidoididae/PCI_Zoology/analyses/04_ghostparser/isidoides') ; list.files()
#read.table("ghostparser_output.txt", sep="\t", header=T) -> gh

read.table("ghostparser_output75.txt", sep="\t", header=T) -> gh
head(gh) ; dim(gh)

# apply FDR correction of p values for multiple testing 
length(gh$DCT_p_value[gh$DCT_p_value<0.01]) # tests significant at alpha=0.01
p.adjust(gh$DCT_p_value, method="fdr") -> adjusted

# check how many significant triplets we loose
length(adjusted[adjusted<0.01])

# renaming taxa to ease interpretation
gh$Taxon_out[grep("clade",gh$Taxon_out)] <-"oct090"
gh$Taxon_A[grep("niwa",gh$Taxon_A)] <-"armata"
gh$Taxon_A[grep("Isidoides_sp",gh$Taxon_A)] <-"pseudarmata"
gh$Taxon_A[grep("elegans",gh$Taxon_A)] <-"elegans"
gh$Taxon_A[grep("gracilis",gh$Taxon_A)] <-"gracilis"
gh$Taxon_A[grep("incrassata",gh$Taxon_A)] <-"armata" # considering incrassata as armata
gh$Taxon_B[grep("niwa",gh$Taxon_B)] <-"armata"
gh$Taxon_B[grep("Isidoides_sp",gh$Taxon_B)] <-"pseudarmata"
gh$Taxon_B[grep("elegans",gh$Taxon_B)] <-"elegans"
gh$Taxon_B[grep("gracilis",gh$Taxon_B)] <-"gracilis"
gh$Taxon_B[grep("incrassata",gh$Taxon_B)] <-"armata" # considering incrassata as armata
gh$Taxon_C[grep("niwa",gh$Taxon_C)] <-"armata"
gh$Taxon_C[grep("Isidoides_sp",gh$Taxon_C)] <-"pseudarmata"
gh$Taxon_C[grep("elegans",gh$Taxon_C)] <-"elegans"
gh$Taxon_C[grep("gracilis",gh$Taxon_C)] <-"gracilis"
gh$Taxon_C[grep("incrassata",gh$Taxon_C)] <-"armata" # considering incrassata as armata

# removing triplets representing intra-specific introgression (C is the focus taxon)
equal3 <- apply(gh[, 1:3], 1, function(x) length(unique(x)) == 1) ## A,B,C are the same species
equal2 <- apply(gh[, 1:2], 1, function(x) length(unique(x)) == 1) ## B,C are the same species
cbind(adjusted,equal2,equal3,gh) -> adj.gh
head(adj.gh)
adj.gh[adj.gh $equal2==FALSE & adj.gh $equal3==FALSE & adj.gh $adjusted<0.01, ] -> keep
head(keep) ; dim(keep)

# we can load again the original dataframe to reveal the sample names involved in the significant triplets
read.table("ghostparser_output.txt", sep="\t", header=T) -> GH
GH[rownames(keep),]