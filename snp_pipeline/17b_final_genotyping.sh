#!/bin/bash

#SBATCH --cpus-per-task=4
#SBATCH --mem=16G
#SBATCH --time=12:00:00

# follows Erickson_etal_2021_Sinularia_Alcyonium_SNP_Calling_Pipeline Code.docx
# this script is based on 2_indelrealigner-WLET_copy.sh from https://github.com/zarzamora23/SNPs_from_UCEs
# and on https://github.com/Lavarchus/SNP-calling-GATK4/blob/main/snp_calling_GATK4.sh

module load gatk4/4.6.1.0

OUTDIR=/shared/projects/daunpapua/Isidoides/uce/snp_calling
REFERENCE="${OUTDIR}/ref-ONLY-UCE.fasta"

cd $OUTDIR
find ${OUTDIR} -type f -name "*_recal2.g.vcf" > gvcf.list

# Consolidate all g.vcf files
gatk CombineGVCFs \
    -R ${REFERENCE} \
    -V ${OUTDIR}/gvcf.list \
    -O ${OUTDIR}/combined_gvcf_recal2.vcf

# Joint Genotypiing                                                                                                                                                           
gatk GenotypeGVCFs \
    -R ${REFERENCE} \
    -V ${OUTDIR}/combined_gvcf_recal2.vcf \
    -O ${OUTDIR}/genotyped_samples_recal2.vcf

# Extract SNPSs from callset
gatk SelectVariants \
	-R ${REFERENCE} \
	-V ${OUTDIR}/genotyped_samples_recal2.vcf \
	-select-type SNP \
	-O ${OUTDIR}/genotyped_samples_snps_recal2.vcf

# Extract indels from callset
gatk SelectVariants \
	-R ${REFERENCE} \
	-V ${OUTDIR}/genotyped_samples_recal2.vcf \
	-select-type INDEL \
	-O ${OUTDIR}/genotyped_samples_indels_recal2.vcf
