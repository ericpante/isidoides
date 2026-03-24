setwd('~/ownCloud/Xu_etal_2026_Isidoididae/PCI_Zoology/analyses/pca/')
list.files()

library(tidyverse)
library(readr)

pca <- read_table("./Isidoides_final_biallelic_snps_nomissing_oneperuce_pca.eigenvec", col_names = FALSE)
eigenval <- scan("./Isidoides_final_biallelic_snps_nomissing_oneperuce_pca.eigenval")

# Unfortunately, we need to do a bit of legwork to get our data into reasonable shape. First we will remove a nuisance column (plink outputs the individual ID twice). We will also give our pca data.frame proper column names.

# sort out the pca data
# remove nuisance column
pca <- pca[,-1]
# set names
names(pca)[1] <- "ind"
names(pca)[2:ncol(pca)] <- paste0("PC", 1:(ncol(pca)-1))

# sort out the individual species
spp <- rep(NA, length(pca$ind))
spp[grep("armata", pca$ind)] <- "armata"
spp[grep("elegans", pca$ind)] <- "elegans"
spp[grep("pseudarmata", pca$ind)] <- "pseudarmata"
spp[grep("gracilis", pca$ind)] <- "gracilis"
spp[grep("incrassata", pca$ind)] <- "incrassata"

# sort out the individual species
species <- rep(NA, length(pca$ind))
species[grep("armata", pca$ind)] <- "armata"
species[grep("elegans", pca$ind)] <- "elegans"
species[grep("pseudarmata", pca$ind)] <- "pseudarmata"
species[grep("gracilis", pca$ind)] <- "gracilis"
species[grep("incrassata", pca$ind)] <- "incrassata"
pca <- as_tibble(data.frame(pca, species))

# first convert to percentage variance explained
pve <- data.frame(PC = 1:20, pve = eigenval/sum(eigenval)*100)

# With that done, it is very simple to create a bar plot showing the percentage of variance each principal component explains.

a <- ggplot(pve, aes(PC, pve)) + geom_bar(stat = "identity")
a + ylab("Percentage variance explained") + theme_light()
cumsum(pve$pve)

# plot pca

grac="#56B4E9" 		# bleu
eleg="#E69F00"		# orange
arma="grey20" 		# noir
pseu="#009E73"		# vert
incra="#CC79A7"	# rose

b <- ggplot(pca, aes(PC1, PC2, fill = species)) + geom_point(size = 4, shape = 21, color = "black", stroke = 0.1)
b <- b + scale_fill_manual(values = c(arma,eleg,grac,incra,pseu))
b <- b + coord_equal() + theme_light()
b + xlab(paste0("PC1 (", signif(pve$pve[1], 3), "%)")) + ylab(paste0("PC2 (", signif(pve$pve[2], 3), "%)"))
