#!/bin/bash

################################ Slurm options #################################

### Job name
#SBATCH --job-name=astral3

## Limit run time "days-hours:minutes:seconds"
#SBATCH --time=00:30:00

### Requirement
#SBATCH --partition=fast
#SBATCH --mem=10G
#SBATCH --cpus-per-task=32
#SBATCH --account=daunpapua

## ASTRAL species tree
module load java-jdk/11.0.9.1

#trees=/shared/projects/daunpapua/Isidoides/out_trees/uce75p_locustrees
#astr=/shared/projects/daunpapua/Isidoides/astral/ASTRAL-master/Astral
#out=/shared/projects/daunpapua/Isidoides/out_trees/uce75p_astral

#java -jar $astr/astral.5.7.8.jar \
#     -i $trees/mafft-internal-trimmed-gblocks-clean-75p-raxml.charsets.treefile \
#     -o $out/mafft-internal-trimmed-gblocks-clean-75p-raxml.charsets.tree \
#     -t 2

#trees=/shared/projects/daunpapua/Isidoides/out_trees/uce90p_locustrees
#astr=/shared/projects/daunpapua/Isidoides/astral/ASTRAL-master/Astral
#out=/shared/projects/daunpapua/Isidoides/out_trees/uce90p_astral

#java -jar $astr/astral.5.7.8.jar \
#     -i $trees/mafft-internal-trimmed-gblocks-clean-90p-raxml.charsets.treefile \
#     -o $out/mafft-internal-trimmed-gblocks-clean-90p-raxml.charsets.tree \
#     -t 2

trees=/shared/projects/daunpapua/Isidoides/out_trees/uce100p_locustrees
astr=/shared/projects/daunpapua/Isidoides/astral/ASTRAL-master/Astral
out=/shared/projects/daunpapua/Isidoides/out_trees/uce100p_astral

java -jar $astr/astral.5.7.8.jar \
     -i $trees/mafft-internal-trimmed-gblocks-clean-100p-raxml.charsets.treefile \
     -o $out/mafft-internal-trimmed-gblocks-clean-100p-raxml.charsets.tree \
     -t 2
