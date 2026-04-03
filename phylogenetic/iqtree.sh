#!/bin/bash

################################ Slurm options #################################

### Job name
#SBATCH --job-name=gntr1

## Limit run time "days-hours:minutes:seconds"
#SBATCH --time=01:00:00

### Requirement
#SBATCH --partition=fast
#SBATCH --mem=50G
#SBATCH --cpus-per-task=32
#SBATCH --account=daunpapua

## Maximum-Likelihood PHYLOGENETIC ANALYSIS

module load iqtree/3.0.1 

data=/shared/projects/daunpapua/Isidoides/data

# trees from concatenated loci

# UCEs
#iqtree -s ${data}/mafft-internal-trimmed-gblocks-clean-75p-raxml.phylip \
#       -p ${data}/mafft-internal-trimmed-gblocks-clean-75p-raxml.charsets \
#       -m MFP+MERGE -B 1000 --bnni -alrt 1000 -nt AUTO
#iqtree -s ${data}/mafft-internal-trimmed-gblocks-clean-90p-raxml.phylip \
#	-p ${data}/mafft-internal-trimmed-gblocks-clean-90p-raxml.charsets \
#	-m MFP+MERGE -B 1000 --bnni -alrt 1000 -nt AUTO
iqtree -s ${data}/mafft-internal-trimmed-gblocks-clean-100p-raxml.phylip \
       -p ${data}/mafft-internal-trimmed-gblocks-clean-100p-raxml.charsets \
       -m MFP+MERGE -B 1000 --bnni -alrt 1000 -nt AUTO

# Sanger
#iqtree -s ${data}/28S.fas -m MFP -B 1000 -bnni  -alrt 1000 -nt AUTO
#iqtree -s ${data}/mtmuts-cox1.fas  -m MFP -B 1000 -bnni	-alrt 1000 -nt AUTO


# Locus trees

#iqtree -s ${data}/mafft-internal-trimmed-gblocks-clean-100p-raxml.phylip \
#       -p ${data}/mafft-internal-trimmed-gblocks-clean-100p-raxml.charsets \
#       -S ${data}/mafft-internal-trimmed-gblocks-clean-100p-raxml.charsets \
#       -m MFP+MERGE -nt 32                                                                   

#iqtree -s ${data}/mafft-internal-trimmed-gblocks-clean-75p-raxml.phylip \
#       -p ${data}/mafft-internal-trimmed-gblocks-clean-75p-raxml.charsets \
#       -S ${data}/mafft-internal-trimmed-gblocks-clean-75p-raxml.charsets \
#       -m MFP+MERGE -nt 32

#iqtree -s ${data}/mafft-internal-trimmed-gblocks-clean-90p-raxml.phylip \
#       -p ${data}/mafft-internal-trimmed-gblocks-clean-90p-raxml.charsets \
#       -S ${data}/mafft-internal-trimmed-gblocks-clean-90p-raxml.charsets \
#       -m MFP+MERGE -nt 32                                                                   
