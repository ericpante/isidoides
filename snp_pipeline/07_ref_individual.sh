#!/bin/bash

#SBATCH --cpus-per-task=16
#SBATCH --mem=16G
#SBATCH --time=01:00:00

# follows Erickson_etal_2021_Sinularia_Alcyonium_SNP_Calling_Pipeline Code.docx

module load phyluce/1.7.3 

# Choose reference individual by finding the individual with the most UCE/exon contigs
cd /shared/projects/daunpapua/Isidoides/uce/spades-assemblies/UCE/log
grep " uniques of"  phyluce_assembly_match_contigs_to_probes.log # octoIsidoides_gracilis_MBM286878

# Create fasta of UCE/exon loci from the reference individual using phyluce programs
cd /shared/projects/daunpapua/Isidoides/uce
mkdir snp_calling
cd snp_calling
touch ref.config
echo [ref] >> ref.config 
echo octoIsidoides_gracilis_MBM286878   >> ref.config
cd ..

path2sqlite=/shared/projects/daunpapua/Isidoides/uce/spades-assemblies/UCE/uce-search-results
path2ref=/shared/projects/daunpapua/Isidoides/uce/snp_calling

phyluce_assembly_get_match_counts \
    	--locus-db $path2sqlite/probe.matches.sqlite \
    	--taxon-list-config $path2ref/ref.config \
    	--taxon-group 'ref' \
	--output $path2ref/ref-ONLY.conf

# Run phyluce program to create fasta file of loci present in the reference individual

cd /shared/projects/daunpapua/Isidoides/uce

path2contigs=/shared/projects/daunpapua/Isidoides/uce/spades-assemblies/contigs
path2sqlite=/shared/projects/daunpapua/Isidoides/uce/spades-assemblies/UCE/uce-search-results
path2ref_ONLY=/shared/projects/daunpapua/Isidoides/uce/snp_calling

phyluce_assembly_get_fastas_from_match_counts \
    --contigs $path2contigs \
    --locus-db $path2sqlite/probe.matches.sqlite \
    --match-count-output $path2ref_ONLY/ref-ONLY.conf \
    --output $path2ref_ONLY/ref-ONLY-UCE.fasta
