# Isidoides, Structure plots
# eric pante, 2026-03-26

# plot K=5 in same order as astral tree

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

index=c(
grep("I.arm_2008-1506",names),
grep("I.arm_2008-1505",names),
grep("I.arm_2008-1504",names),
grep("I.arm_2008-1411",names),
grep("I.arm_2008-1510",names),
grep("I.arm_2009-1632",names),
grep("I.arm_2008-1507",names),
grep("I.arm_2016-2540",names),
grep("I.arm_MBM286881",names),
grep("I.inc_MBM286882",names),
grep("I.pse_2008-1869",names),
grep("I.pse_2008-1508",names),
grep("I.pse_2008-1509",names),
grep("I.pse_2008-1867",names),
grep("I.pse_2008-1875",names),
grep("I.gra_MBM286879",names),
grep("I.gra_MBM286877",names),
grep("I.gra_MBM286878",names),
grep("I.gra_MBM286880",names),
grep("I.ele_MBM286501",names),
grep("I.ele_MBM286500",names)
)

grac="#56B4E9" 		# bleu
eleg="#E69F00"		# orange
arma="grey20" 		# noir
pseu="#009E73"		# vert
incra="#CC79A7"	# rose

rownames(tab) <- names
file="K5_rep17_q"
col=c(incra,eleg,grac,pseu,arma)
read.table(file, head=F)-> tab # [,order]
length(tab[1,]) -> N # K=N-1
barplot(t(tab[index,2:N]), space=F, border="grey30", ylab=paste("K =",N-1),las=0, col=col)

