# Isidoides, Structure plots
# eric pante, 2026-03-26

#setwd('~/ownCloud/Xu_etal_2026_Isidoididae/PCI_Zoology/analyses/00_structure/results_nomaf/')
setwd('~/ownCloud/Xu_etal_2026_Isidoididae/PCI_Zoology/analyses/00_structure/results_maf/')

grac="#56B4E9" 		# bleu
eleg="#E69F00"		# orange
arma="grey20" 		# noir
pseu="#009E73"		# vert
incra="#CC79A7"	# rose

names=c(
"I.arm_2008-1411",
"I.arm_2008-1504",
"I.arm_2008-1505",
"I.arm_2008-1506",
"I.arm_2008-1507",
"I.arm_2008-1510",
"I.arm_2009-1632",
"I.arm_2016-2540",
"I.arm_MBM286881",
"I.ele_MBM286500",
"I.ele_MBM286501",
"I.gra_MBM286877",
"I.gra_MBM286878",
"I.gra_MBM286879",
"I.gra_MBM286880",
"I.inc_MBM286882",
"I.pse_2008-1508",
"I.pse_2008-1509",
"I.pse_2008-1867",
"I.pse_2008-1869",
"I.pse_2008-1875"
)

structure=function(file,col){ # ,order
	read.table(file, head=F)-> tab # [,order]
	length(tab[1,])->K
	barplot(t(tab[,2:K]), space=F, border="grey30", 
			ylab=paste("K =",K-1),las=1, col=col)
}

# choosing most likely replicate : grep "Mean value of ln likelihood" K2_rep*_f

# # no maf
# par(mfrow=c(7,1),mai=c(0.05,0.7,0.05,0.05), omi=c(1.2,0,0,0))
# structure("K2_rep6_q", c(grac,arma))
# structure("K3_rep10_q", c(grac,pseu,arma))
# structure("K4_rep10_q", c(arma,grac,pseu,eleg))
# structure("K5_rep1_q", c(incra,pseu,eleg,grac,arma))
# structure("K6_rep10_q", c(grac,'gray20',pseu,incra,arma,eleg))
# structure("K7_rep10_q", c(grac,'gray20',pseu,incra,eleg,'gray50',arma))
# structure("K8_rep3_q", c(pseu,'gray20',arma,eleg,'gray50',grac,incra,'gray70'))
# axis(1,at=seq(0.5,20.5,1),lab=names, las = 2)

# maf 5%
par(mfrow=c(7,1),mai=c(0.05,0.7,0.05,0.05), omi=c(1.2,0,0,0))
structure("K2_rep13_q", c(arma, grac)) # , c(1,2,3)
structure("K3_rep12_q", c(pseu,arma,grac)) # , c(1,2,3,4)
structure("K4_rep1_q", c(grac,eleg,arma,pseu)) # , c(1,2,3,4,5)
structure("K5_rep17_q", c(incra,eleg,grac,pseu,arma)) # , c(1,5,2,3,4,6)
structure("K6_rep2_q", c(arma,eleg,pseu,incra,grac,"gray50"))
structure("K7_rep2_q", c(pseu,eleg,"gray50",incra,"gray70",arma,grac))
structure("K8_rep1_q", c("gray50",grac,"gray10",eleg,incra,"gray90",pseu,arma))
axis(1,at=seq(0.5,20.5,1),lab=names, las = 2)


# polymorphism data from vcftools
setwd('~/ownCloud/Xu_etal_2026_Isidoididae/PCI_Zoology/analyses/structure/')
read.table("Isidoides_final_biallelic_snps_nomissing_oneperuce.recode.stats.frq", h=T)->frq ; head(frq)
read.table("Isidoides_final_biallelic_snps_nomissing_oneperuce.recode.stats.het", h=T)->het ; head(het)
read.table("Isidoides_final_biallelic_snps_nomissing_oneperuce.recode.stats.sites.pi", h=T)->s.pi ; head(s.pi)

barplot(F~INDV, data=het, las=2)
hist(frq$FREQ1)
hist(s.pi$PI)

