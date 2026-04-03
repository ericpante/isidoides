#!/bin/bash

#SBATCH --cpus-per-task=4
#SBATCH --mem=16G
#SBATCH --time=12:00:00

# follows Erickson_etal_2021_Sinularia_Alcyonium_SNP_Calling_Pipeline Code.docx
# and https://github.com/Lavarchus/SNP-calling-GATK4/blob/main/snp_calling_GATK4.sh

module load vcftools/0.1.16
module load plink/1.90b6.18 # cannot use plink2 for recode structure

RUNDIR=/shared/projects/daunpapua/Isidoides/uce
OUTDIR=/shared/projects/daunpapua/Isidoides/uce/snp_calling
cd $OUTDIR

CONFIG="$RUNDIR/snp.config"
SAMPLE=$(awk -v ArrayTaskID=$SLURM_ARRAY_TASK_ID '$1==ArrayTaskID {print$2}' $CONFIG)
REFERENCE="$OUTDIR/ref-ONLY-UCE.fasta"

# Filter and reformat SNPs using vcftools for downstream analysis following parameters set by Erickson et al. (2021)
# --thin 1000      : Thin sites so that no two sites are within the specified distance from one another.
#                    Here we set it so that there is one snp / uce
# --max-non-ref-af : freq pf non-ref allele : I don't use it (nor do I use --maf) because I have
# a species represented by one individual & 21 specimens in total.

# I iterate vcftools so that (1) I keep only snps with no missing data, (2) I keep 1/uce 
vcftools \
    --vcf bqsr_snps_recal2.vcf \
    --min-alleles 2 \
    --max-alleles 2 \
    --max-missing 1 \
    --recode \
    --out bqsr_snps_recal2_nomissing.vcf

vcftools \
    --vcf bqsr_snps_recal2_nomissing.vcf.recode.vcf \
    --thin 1500 \
    --recode \
    --out Isidoides_final_biallelic_snps_nomissing_oneperuce

## Reformat with Plink to use in structure analysis
## --const-fid 0 converts sample IDs to within-family IDs while setting all family IDs to a single value (default '0').
##               Basically it tells Plink to use the same name as those set in the vcf file
## --allow-extra-chr allows new contig name format e.g uce-...

plink --vcf Isidoides_final_biallelic_snps_nomissing_oneperuce.recode.vcf \
    --const-fid 0 \
    --allow-extra-chr \
    --recode structure \
    --out Isidoides_final_biallelic_snps_nomissing_oneperuce_structure

# stats

vcftools \
    --vcf Isidoides_final_biallelic_snps_nomissing_oneperuce.recode.vcf \
    --freq \
    --out Isidoides_final_biallelic_snps_nomissing_oneperuce.recode.stats
	 
vcftools \
    --vcf Isidoides_final_biallelic_snps_nomissing_oneperuce.recode.vcf \
    --het \
    --out Isidoides_final_biallelic_snps_nomissing_oneperuce.recode.stats

vcftools \
    --vcf Isidoides_final_biallelic_snps_nomissing_oneperuce.recode.vcf \
    --site-pi \
    --out Isidoides_final_biallelic_snps_nomissing_oneperuce.recode.stats

# pca with plink: https://speciationgenomics.github.io/pca/
plink --vcf Isidoides_final_biallelic_snps_nomissing_oneperuce.recode.vcf \
      --const-fid 0 --allow-extra-chr --pca \
      --out Isidoides_final_biallelic_snps_nomissing_oneperuce_pca
