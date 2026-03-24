setwd('~/ownCloud/Xu_etal_2026_Isidoididae/PCI_Zoology/analyses/structure/results/')

grac="#56B4E9" 		# bleu
eleg="#E69F00"		# orange
arma="grey20" 		# noir
pseu="#009E73"		# vert
incra="#CC79A7"	# rose

bleu="#56B4E9" 		# bleu
oran="#E69F00"		# orange
noir="grey20" 		# noir
vert="#009E73"		# vert
rose="#CC79A7"	# rose

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

structure=function(file,col){
	read.table(file, head=F)-> tab
	length(tab[1,])->K
	barplot(t(tab[,2:K]), space=F, border="grey30", 
			ylab=paste("K =",K-1),las=1, col=col)
}

# choosing most likely replicate : grep "Mean value of ln likelihood" K2_rep*_f

par(mfrow=c(7,1),mai=c(0.05,0.7,0.05,0.05), omi=c(1.2,0,0,0))
structure("K2_rep6_q", c(grac,arma))
structure("K3_rep10_q", c(bleu,vert,noir))
structure("K4_rep10_q", c(noir,bleu,vert,eleg))
structure("K5_rep1_q", c(rose,vert,oran,bleu,noir))
structure("K6_rep10_q", c(bleu,"gray50",vert,rose,noir,oran))
structure("K7_rep10_q", c(bleu,"gray50",vert,rose,oran,"gray70",arma))
structure("K8_rep3_q", c(pseu,"gray50",arma,eleg,"gray10",grac,incra,"gray90"))
axis(1,at=seq(0.5,20.5,1),lab=names, las = 2)

# polymorphism data from vcftools
setwd('~/ownCloud/Xu_etal_2026_Isidoididae/PCI_Zoology/analyses/structure/')
read.table("Isidoides_final_biallelic_snps_nomissing_oneperuce.recode.stats.frq", h=T)->frq ; head(frq)
read.table("Isidoides_final_biallelic_snps_nomissing_oneperuce.recode.stats.het", h=T)->het ; head(het)
read.table("Isidoides_final_biallelic_snps_nomissing_oneperuce.recode.stats.sites.pi", h=T)->s.pi ; head(s.pi)

barplot(F~INDV, data=het, las=2)
hist(frq$FREQ1)
hist(s.pi$PI)

