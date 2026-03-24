#!/bin/bash

#SBATCH --cpus-per-task=4
#SBATCH --mem=4G
#SBATCH --time=00:10:00

module load dsuite/v0.5_r53

cd /shared/projects/daunpapua/Isidoides/uce/snp_calling
Dsuite Dtrios -c -n test ../snp_calling/Isidoides_final_biallelic_snps_nomissing_oneperuce.recode.vcf SETS.txt

