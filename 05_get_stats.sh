#!/bin/bash

#SBATCH --cpus-per-task=1
#SBATCH --mem=1G
#SBATCH --time=00:10:00

module load phyluce/1.7.3 
cd /shared/projects/daunpapua/Isidoides/uce/spades-assemblies

echo 'samples,contigs,total bp,mean length,95 CI length,min length,max length,median legnth,contigs >1kb' > assembly.csv
for i in contigs/*
do
    phyluce_assembly_get_fasta_lengths --input $i --csv ;
done >> assembly.csv

column -t -s "," assembly.csv
