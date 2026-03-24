library(marmap)

# map 

setwd("~/ownCloud/Xu_etal_2026_Isidoididae/tables")
read.table("Specimen_table_20250904_colours.tsv", header=T, sep="\t") -> spe

spe[-grep ("I.sp", spe$species), ] -> spe # remove "sp"
(spe$depth.max+spe$depth.min)/2 -> spe.mean  # "get mean depth"
cbind(spe,spe.mean) -> spe2 # add it to table
spe2$species_f <- factor(spe2$species, levels = sort(unique(spe2$species))) # insure proper factor ordering

# getNOAA.bathy(110,180,-45,25, res=10) -> bath

par(mfrow=c(1,2))
plot(bath, deep=c(-4500,0), shallow=c(-50,0), step=c(500,0),, cex.axis = 0.7, 
             lwd=c(0.1,1), lty=c(1,1), col=c("black","black"), drawlabels=c(FALSE,FALSE))                         

points(spe$lon, spe$lat,pch=spe$symbol, bg=spe$col, cex=1.2)
legend('topright', legend=unique(spe$species), pch = 21, pt.bg=unique(spe$col), bg="white")

# boxplot
boxplot(-spe.mean ~ species_f,
        data = spe2,
        col = "grey95",
        border = "black",
        xlab = "", cex.axis = 0.7, 
        ylab = "Mean sampling depth (m)")

# x positions corresponding to boxes
x <- as.numeric(spe2$species_f)

# add jittered points
points(jitter(x, amount = 0.12),
       -spe2$spe.mean,
       pch = 21,
       bg = spe2$col,
       col = "black")
    
  # plot(spe2$lat~spe2$spe.mean, 
     # pch=spe$symbol, bg=spe$col,
     # xlab="Mean sampling depth (m)", ylab="Latitude")
# legend('topleft', legend=unique(spe$species), pch = 21, pt.bg=unique(spe$col))
