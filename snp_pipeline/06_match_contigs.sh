#!/bin/bash

#SBATCH --cpus-per-task=16
#SBATCH --mem=16G
#SBATCH --time=01:00:00

#mkdir UCE; cd UCE; mkdir log
module load phyluce/1.7.3 
cd /shared/projects/daunpapua/Isidoides/uce/spades-assemblies/UCE

# get D10150Oc219-baits.fas, then match contigs to it:
# standard regex to identify probe names needed adjusting from '_p' to '-p' to match probe name format
phyluce_assembly_match_contigs_to_probes \
    --contigs ../contigs \
    --probes D10150Oc219-baits.fas \
    --regex '^(uce-\d+)(?:-p\d+.*)' \
    --min-coverage 70 \
    --min-identity 70 \
    --log-path log \
    --output uce-search-results

