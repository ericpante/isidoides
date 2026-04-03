# Isidoides, Ghostparser tests
# eric pante, 2026-03-26

# from list of all possible triplets, remove all that don't make sense, prior to testing introgression

setwd('~/ownCloud/Xu_etal_2026_Isidoididae/PCI_Zoology/analyses/ghostparser/isidoides')
list.files()
read.table("all_triplets.txt", sep=",", header=F) -> gh # all 1330 possible triplets
colnames(gh) <- c("C","B","A") # not the order kept in output ; ghostparser orients pairs according to gene trees
head(gh); dim(gh)

# replace full names by species names

gh$A[grep("niwa",gh$A)] <-"armata"
gh$A[grep("Isidoides_sp",gh$A)] <-"pseudarmata"
gh$A[grep("elegans",gh$A)] <-"elegans"
gh$A[grep("gracilis",gh$A)] <-"gracilis"
gh$A[grep("incrassata",gh$A)] <-"armata" # considering incrassata as armata

gh$B[grep("niwa",gh$B)] <-"armata"
gh$B[grep("Isidoides_sp",gh$B)] <-"pseudarmata"
gh$B[grep("elegans",gh$B)] <-"elegans"
gh$B[grep("gracilis",gh$B)] <-"gracilis"
gh$B[grep("incrassata",gh$B)] <-"armata" # considering incrassata as armata

gh$C[grep("niwa",gh$C)] <-"armata"
gh$C[grep("Isidoides_sp",gh$C)] <-"pseudarmata"
gh$C[grep("elegans",gh$C)] <-"elegans"
gh$C[grep("gracilis",gh$C)] <-"gracilis"
gh$C[grep("incrassata",gh$C)] <-"armata" # considering incrassata as armata

# these are the only valid pairs, dis-regarding intra-specific introgression
# the tree topology is(((armata,incrassata),pseudarmata),(gracilis,elegans)),oct090
# but ghostparser seems to reorder pairs according to the gene trees; 
# order does not seem to matter, we'll sort later.

# if you input 1,2,3 1,3,2 2,3,1 as input, the program outputs a single, oriented triplet.

valid <- with(gh,
(C=="elegans" & B=="armata" & A=="pseudarmata") |
(C=="elegans" & B=="pseudarmata" & A=="armata") |
(C=="gracilis" & B=="armata" & A=="pseudarmata") |
(C=="gracilis" & B=="pseudarmata" & A=="armata") |
(C=="armata" & B=="elegans" & A=="gracilis") |
(C=="armata" & B=="gracilis" & A=="elegans") |
(C=="pseudarmata" & B=="elegans" & A=="gracilis") |
(C=="pseudarmata" & B=="gracilis" & A=="elegans")
)

# now that we have the coordinate of the valid triplets, we apply them to the original dataset, and save

read.table("all_triplets.txt", sep=",", header=F) -> GH # all 1330 possible triplets
GH[valid==TRUE,]
length(GH[valid==TRUE,1])
write.table(GH[valid==TRUE,], "valid_triplets.txt",sep=",",row.names = F, col.names = F,quote=F)
