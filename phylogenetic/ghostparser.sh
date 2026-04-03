
# first time: 
conda create -n ghostparser_env -c conda-forge -c bioconda python=3.12.7 r-base r-dplyr r-rstatix r-argparse newick_utils libevent=2.1.12
conda init fish
conda activate ghostparser_env
git clone https://github.com/asuvorovlab/ghostparser.git
python -m pip install --no-deps ete3==3.1.3
python -m pip install six

# then
conda activate ghostparser_env
cd ~/ownCloud/Xu_etal_2026_Isidoididae/PCI_Zoology/analyses/04_ghostparser/isidoides


# testing for introgression among species, considering incrasssata as armata
python ../bin/ghostparser.py \
	--out_taxa Out.txt \
	--input_trees genetrees_mafft-internal-trimmed-gblocks-clean-100p-raxml.charsets.tree \
	--species_tree speciestree_mafft-internal-trimmed-gblocks-clean-100p-raxml.charsets.tree \
	--triplets valid_triplets.txt \
	--output_file ghostparser_output.txt

# testing for introgression between incrasssata and armata
python ../bin/ghostparser.py \
	--out_taxa Out.txt \
	--input_trees genetrees_mafft-internal-trimmed-gblocks-clean-100p-raxml.charsets.tree \
	--species_tree speciestree_mafft-internal-trimmed-gblocks-clean-100p-raxml.charsets.tree \
	--triplets incrassata_triplets.txt \
	--output_file ghostparser_output_incrassata.txt

# testing for introgression among species, considering incrasssata as armata, different UCE matrices
python ../bin/ghostparser.py \
        --out_taxa Out.txt \
        --input_trees genetrees_mafft-internal-trimmed-gblocks-clean-75p-raxml.charsets.tree \
        --species_tree speciestree_mafft-internal-trimmed-gblocks-clean-100p-raxml.charsets.tree \
        --triplets valid_triplets.txt \
        --output_file ghostparser_output75.txt

python ../bin/ghostparser.py \
        --out_taxa Out.txt \
        --input_trees genetrees_mafft-internal-trimmed-gblocks-clean-90p-raxml.charsets.tree \
        --species_tree speciestree_mafft-internal-trimmed-gblocks-clean-100p-raxml.charsets.tree \
        --triplets valid_triplets.txt \
        --output_file ghostparser_output90.txt

# incrassata separate
python ../bin/ghostparser.py \
        --out_taxa Out.txt \
        --input_trees genetrees_mafft-internal-trimmed-gblocks-clean-75p-raxml.charsets.tree \
        --species_tree speciestree_mafft-internal-trimmed-gblocks-clean-100p-raxml.charsets.tree \
        --triplets all_triplets.txt \
        --output_file ghostparser_output75_all.txt
