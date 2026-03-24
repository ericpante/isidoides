#!/bin/bash

#SBATCH --cpus-per-task=32
#SBATCH --mem=64G
#SBATCH --time=4:00:00

module load trimmomatic/0.39
module load phyluce/1.7.3
cd /shared/projects/daunpapua/Isidoides/uce

# run illumiprocessor on fastqs with config file
illumiprocessor \
    --cores 32 \
    --input ./fastq/ \
    --output ./clean-fastq \
    --config Illumiproc.config \
    --r1-pattern "{}_1.fastq.gz" \
    --r2-pattern "{}_2.fastq.gz"
