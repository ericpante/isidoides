setwd('~/ownCloud/Xu_etal_2026_Isidoididae/PCI_Zoology/analyses/pca/')

library(gridExtra)
library(tidyverse)
library(readr)

#    ______________
#___/ without MAF  \________________________________________________

pca.nomaf <- read_table("./Isidoides_final_biallelic_snps_nomissing_oneperuce_pca.eigenvec", col_names = FALSE)
eigenval.nomaf <- scan("./Isidoides_final_biallelic_snps_nomissing_oneperuce_pca.eigenval")

# Unfortunately, we need to do a bit of legwork to get our data into reasonable shape. First we will remove a nuisance column (plink outputs the individual ID twice). We will also give our pca data.frame proper column names.

# sort out the pca data
# remove nuisance column
pca.nomaf <- pca.nomaf[,-1]
# set names
names(pca.nomaf)[1] <- "ind"
names(pca.nomaf)[2:ncol(pca.nomaf)] <- paste0("PC", 1:(ncol(pca.nomaf)-1))

# sort out the individual cluster
cluster <- rep(NA, length(pca.nomaf$ind))
cluster[grep("_armata_", pca.nomaf$ind)] <- "armata form 1-4"
cluster[grep("elegans", pca.nomaf$ind)] <- "elegans"
cluster[grep("pseudarmata", pca.nomaf$ind)] <- "pseudarmata"
cluster[grep("gracilis", pca.nomaf$ind)] <- "gracilis"
cluster[grep("incrassata", pca.nomaf$ind)] <- "armata form 5"
pca.nomaf <- as_tibble(data.frame(pca.nomaf, cluster))

# first convert to percentage variance explained
pve.nomaf <- data.frame(PC = 1:20, pve = eigenval.nomaf/sum(eigenval.nomaf)*100)

# With that done, it is very simple to create a bar plot showing the percentage of variance each principal component explains.

a.nomaf <- ggplot(pve.nomaf, aes(PC, pve)) + geom_bar(stat = "identity")
a.nomaf + ylab("Percentage variance explained") + theme_light()
cumsum(pve.nomaf$pve)

# plot pca

grac="#56B4E9" 		# bleu
eleg="#E69F00"		# orange
arma="grey20"			# noir
pseu="#009E73"		# vert
incra="#CC79A7"		# rose

b.nomaf <- ggplot(pca.nomaf, aes(PC1, PC2, fill = cluster)) + geom_point(size = 4, shape = 21, color = "black", stroke = 0.1)
b.nomaf <- b.nomaf + scale_fill_manual(values = c(arma,incra,eleg,grac,pseu))
b.nomaf <- b.nomaf + coord_equal() + theme_light()
b.nomaf <- b.nomaf + xlab(paste0("PC1 (", signif(pve$pve[1], 3), "%)")) + ylab(paste0("PC2 (", signif(pve$pve[2], 3), "%)"))

#    __________
#___/ with MAF \________________________________________________

pca.withmaf <- read_table("./Isidoides_final_biallelic_snps_maf_nomissing_oneperuce_pca.eigenvec", col_names = FALSE)
eigenval.withmaf <- scan("./Isidoides_final_biallelic_snps_maf_nomissing_oneperuce_pca.eigenval")

# Unfortunately, we need to do a bit of legwork to get our data into reasonable shape. First we will remove a nuisance column (plink outputs the individual ID twice). We will also give our pca data.frame proper column names.

# sort out the pca data
# remove nuisance column
pca.withmaf <- pca.withmaf[,-1]
# set names
names(pca.withmaf)[1] <- "ind"
names(pca.withmaf)[2:ncol(pca.withmaf)] <- paste0("PC", 1:(ncol(pca.withmaf)-1))

# sort out the individual cluster
cluster <- rep(NA, length(pca.withmaf$ind))
cluster[grep("_armata_", pca.withmaf$ind)] <- "armata form 1-4"
cluster[grep("elegans", pca.withmaf$ind)] <- "elegans"
cluster[grep("pseudarmata", pca.withmaf$ind)] <- "pseudarmata"
cluster[grep("gracilis", pca.withmaf$ind)] <- "gracilis"
cluster[grep("incrassata", pca.withmaf$ind)] <- "armata form 5"
pca.withmaf <- as_tibble(data.frame(pca.withmaf, cluster))

# first convert to percentage variance explained
pve.withmaf <- data.frame(PC = 1:20, pve = eigenval.withmaf/sum(eigenval.withmaf)*100)

# With that done, it is very simple to create a bar plot showing the percentage of variance each principal component explains.

a <- ggplot(pve.withmaf, aes(PC, pve)) + geom_bar(stat = "identity")
a + ylab("Percentage variance explained") + theme_light()
cumsum(pve.withmaf$pve)

# plot pca

grac="#56B4E9" 	# bleu
eleg="#E69F00"		# orange
arma="grey20" 		# noir
pseu="#009E73"		# vert
incra="#CC79A7"	# rose

b.withmaf <- ggplot(pca.withmaf, aes(PC1, PC2, fill = cluster)) + geom_point(size = 4, shape = 21, color = "black", stroke = 0.1)
b.withmaf <- b.withmaf + scale_fill_manual(values = c(arma,incra,eleg,grac,pseu))
b.withmaf <- b.withmaf + coord_equal() + theme_light()
b.withmaf <- b.withmaf + xlab(paste0("PC1 (", signif(pve$pve[1], 3), "%)")) + ylab(paste0("PC2 (", signif(pve$pve[2], 3), "%)"))

grid.arrange(b.nomaf, b.withmaf, nrow=2)