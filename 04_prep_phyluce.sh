#!/bin/bash

#SBATCH --cpus-per-task=1
#SBATCH --mem=1G
#SBATCH --time=00:10:00

## prepare CONTIG folder and get stats

cd /shared/projects/daunpapua/Isidoides/uce/spades-assemblies
mkdir ./spades-assemblies/contigs

for d in */
do 
  s=${d%/}; # removes trailing dash of directory name 
  [ "$s" = contigs ] && continue; # skip the contigs directory
  ln -sfn "$(pwd)/$s/contigs.fasta" "contigs/$s.fasta"; # Create the symbolic link
done

# removed octoIsidoides_armata_2016-2539.fasta and octoIsidoides_armata_2011-1000.fasta
