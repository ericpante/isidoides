#!/bin/bash

#SBATCH --cpus-per-task=16
#SBATCH --mem=64G
#SBATCH --time=6:00:00
# #SBATCH --array=2-23

## ASSEMBLE CONTIGS
module load spades/4.2.0

#config=/shared/projects/daunpapua/Isidoides/uce/Spades.config
#dirname=$(awk -v ArrayTaskID=$SLURM_ARRAY_TASK_ID '$1==ArrayTaskID {print$2}' $config)
dirname=Isidoides_armata_2008-1506

cd /shared/projects/daunpapua/Isidoides/uce/clean-fastq

spades.py --sc --cov-cutoff 2 \
  -o '../spades-assemblies/octo'${dirname} \
  -1 ${dirname}'/split-adapter-quality-trimmed/'${dirname}'-READ1.fastq.gz' \
  -2 ${dirname}'/split-adapter-quality-trimmed/'${dirname}'-READ2.fastq.gz' \
  -s ${dirname}'/split-adapter-quality-trimmed/'${dirname}'-READ-singleton.fastq.gz'
