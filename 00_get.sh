#!/bin/bash

#SBATCH --cpus-per-task=8
#SBATCH --mem=16G
#SBATCH --time=2:00:00

module load sra-tools/3.1.1

# convert to FASTQ
for r in $(cat runs2.txt); do
    fasterq-dump $r --split-files -e 16
done
