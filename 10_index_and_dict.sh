#!/bin/bash

#SBATCH --cpus-per-task=16
#SBATCH --mem=16G
#SBATCH --time=01:00:00
#SBATCH --array=1-21

# follows Erickson_etal_2021_Sinularia_Alcyonium_SNP_Calling_Pipeline Code.docx
# this script is based on 2_indelrealigner-WLET_copy.sh from https://github.com/zarzamora23/SNPs_from_UCEs
# and on https://github.com/Lavarchus/SNP-calling-GATK4/blob/main/snp_calling_GATK4.sh

module load samtools/1.21
module load picard/2.23.5

cd /shared/projects/daunpapua/Isidoides/uce/snp_calling
path=/shared/projects/daunpapua/Isidoides/uce/snp_calling

config=/shared/projects/daunpapua/Isidoides/uce/Indel.config
sample=$(awk -v ArrayTaskID=$SLURM_ARRAY_TASK_ID '$1==ArrayTaskID {print$2}' $config)
path2sample=/shared/projects/daunpapua/Isidoides/uce/snp_calling/

#The GATK uses two files to access and safety check access to the reference files: 
# .dict dictionary of the contig names and sizes 
# .fai fasta index file to allow efficient random access to the reference bases. 
#prepare fasta file to use as reference with picard and samtools. 

picard CreateSequenceDictionary \
       R=$path/ref-ONLY-UCE.fasta \
       O=$path/ref-ONLY-UCE.dict

samtools faidx $path/ref-ONLY-UCE.fasta
