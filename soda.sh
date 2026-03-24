# fish shell
# "set soda /Applications/bioinfo/SODA-master/" is equivalent to bash "soda=/Applications/bioinfo/SODA-master/"

######################################
#### analyses with unrooted trees ####
######################################

# SODA analysis for UCE 90% occupancy

set soda /Applications/bioinfo/SODA-master/
set astral /Applications/bioinfo/ASTRAL-master/Astral/
set guide /Users/epante/ownCloud/Xu_etal_2026_Isidoididae/PCI_Zoology/analyses/soda/out_trees/uce90p_astral
set trees /Users/epante/ownCloud/Xu_etal_2026_Isidoididae/PCI_Zoology/analyses/soda/out_trees/uce90p_locustrees
set out /Users/epante/ownCloud/Xu_etal_2026_Isidoididae/PCI_Zoology/analyses/soda/out_soda/uce90p_delim

cat $guide/mafft-internal-trimmed-gblocks-clean-90p-raxml.charsets.tree | sed -E "s/'[^']*'//g" > $guide/mafft-internal-trimmed-gblocks-clean-90p-raxml_for_soda.charsets.tree

python3 $soda/run_delimitation.py \
	-j $astral \
	-i $trees/mafft-internal-trimmed-gblocks-clean-90p-raxml.charsets.treefile \
	-t $guide/mafft-internal-trimmed-gblocks-clean-90p-raxml_for_soda.charsets.tree \
	-d $out \
	-o uce90p_delim.txt

####################################
# SODA analysis for UCE 75% occupancy

set soda /Applications/bioinfo/SODA-master/
set astral /Applications/bioinfo/ASTRAL-master/Astral/
set guide /Users/epante/ownCloud/Xu_etal_2026_Isidoididae/PCI_Zoology/analyses/soda/out_trees/uce75p_astral
set trees /Users/epante/ownCloud/Xu_etal_2026_Isidoididae/PCI_Zoology/analyses/soda/out_trees/uce75p_locustrees
set out /Users/epante/ownCloud/Xu_etal_2026_Isidoididae/PCI_Zoology/analyses/soda/out_soda/uce75p_delim/

cat $guide/mafft-internal-trimmed-gblocks-clean-75p-raxml.charsets.tree | sed -E "s/'[^']*'//g" > $guide/mafft-internal-trimmed-gblocks-clean-75p-raxml_for_soda.charsets.tree

python3 $soda/run_delimitation.py \
	-j $astral \
	-i $trees/mafft-internal-trimmed-gblocks-clean-75p-raxml.charsets.treefile \
	-t $guide/mafft-internal-trimmed-gblocks-clean-75p-raxml_for_soda.charsets.tree \
	-d $out \
	-o uce75p_delim.txt

####################################
# SODA analysis for UCE 100% occupancy

set soda /Applications/bioinfo/SODA-master/
set astral /Applications/bioinfo/ASTRAL-master/Astral/
set guide /Users/epante/ownCloud/Xu_etal_2026_Isidoididae/PCI_Zoology/analyses/soda/out_trees/uce100p_astral
set trees /Users/epante/ownCloud/Xu_etal_2026_Isidoididae/PCI_Zoology/analyses/soda/out_trees/uce100p_locustrees
set out /Users/epante/ownCloud/Xu_etal_2026_Isidoididae/PCI_Zoology/analyses/soda/out_soda/uce100p_delim/

cat $guide/mafft-internal-trimmed-gblocks-clean-100p-raxml.charsets.tree | sed -E "s/'[^']*'//g" > $guide/mafft-internal-trimmed-gblocks-clean-100p-raxml_for_soda.charsets.tree

python3 $soda/run_delimitation.py \
	-j $astral \
	-i $trees/mafft-internal-trimmed-gblocks-clean-100p-raxml.charsets.treefile \
	-t $guide/mafft-internal-trimmed-gblocks-clean-100p-raxml_for_soda.charsets.tree \
	-d $out \
	-o uce100p_delim.txt

######################################
#### analyses with different pval ####
######################################

python3 $soda/run_delimitation.py \
	-j $astral \
	-i $trees/mafft-internal-trimmed-gblocks-clean-100p-raxml.charsets.treefile \
	-t $guide/mafft-internal-trimmed-gblocks-clean-100p-raxml_for_soda.charsets.tree \
	-c 0.01 \
	-d $out \
	-o uce100p_delim_pval0.01.txt

python3 $soda/run_delimitation.py \
	-j $astral \
	-i $trees/mafft-internal-trimmed-gblocks-clean-90p-raxml.charsets.treefile \
	-t $guide/mafft-internal-trimmed-gblocks-clean-90p-raxml_for_soda.charsets.tree \
	-c 0.01 \
	-d $out \
	-o uce90p_delim_pval0.01.txt

python3 $soda/run_delimitation.py \
	-j $astral \
	-i $trees/mafft-internal-trimmed-gblocks-clean-75p-raxml.charsets.treefile \
	-t $guide/mafft-internal-trimmed-gblocks-clean-75p-raxml_for_soda.charsets.tree \
	-c 0.01 \
	-d $out \
	-o uce75p_delim_pval0.01.txt

### isolate localPP (pp1) for plotting : 

cd /Users/epante/ownCloud/Xu_etal_2026_Isidoididae/PCI_Zoology/analyses/soda/out_trees/uce100p_astral
perl -pe 's/\[.*?pp1=([0-9.]+).*?\]/$1/g' mafft-internal-trimmed-gblocks-clean-100p-raxml.charsets.tree > mafft-internal-trimmed-gblocks-clean-100p-raxml_pp1.charsets.tree

cd /Users/epante/ownCloud/Xu_etal_2026_Isidoididae/PCI_Zoology/analyses/soda/out_trees/uce90p_astral
perl -pe 's/\[.*?pp1=([0-9.]+).*?\]/$1/g' mafft-internal-trimmed-gblocks-clean-90p-raxml.charsets.tree > mafft-internal-trimmed-gblocks-clean-90p-raxml_pp1.charsets.tree

cd /Users/epante/ownCloud/Xu_etal_2026_Isidoididae/PCI_Zoology/analyses/soda/out_trees/uce75p_astral
perl -pe 's/\[.*?pp1=([0-9.]+).*?\]/$1/g' mafft-internal-trimmed-gblocks-clean-75p-raxml.charsets.tree > mafft-internal-trimmed-gblocks-clean-750p-raxml_pp1.charsets.tree

### format ipt labels for publication 

cd /Users/epante/ownCloud/Xu_etal_2026_Isidoididae/PCI_Zoology/analyses/soda/out_trees/uce75p_astral
awk 'NR==FNR {map[$1]=$2; next} {for (old in map) gsub(old, map[old])} 1' tip_labels.txt mafft-internal-trimmed-gblocks-clean-750p-raxml_pp1.charsets.tree > mafft-internal-trimmed-gblocks-clean-750p-raxml_pp1_newnames.charsets.tree

