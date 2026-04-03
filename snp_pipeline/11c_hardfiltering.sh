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

# Filter variants according to filter expression to improve call set
# Note: if working on exons or uces from invertebrates might be better to use the SOR filter, which is an alternative to estimating strand bias (like FS) because FS tend to penalize variants occuring at the ends of exons and uces are mainly exonic in inverts. Reads at the ends of exons tend to only be covered by reads in one direction and FS gives those vriants a bad score so adding SOR will take into account the ratios of reads that cover both alleles. It's generally better for hig coverage data.
# OPTION for filtering ONLY snps that aren't around or within indels by masking and filtering indels out from the snp vcf file using either the "light-filtered" indel vcf file from joint genotyping or the hard filtered indel vcf file from VariantFiltration + SelectVariants. To do so, uncomment the three masking flags.

gatk VariantFiltration \
    -R ${REFERENCE}  \
    -V ${OUTDIR}/genotyped_samples_snps.vcf \
    --mask ${OUTDIR}/genotyped_samples_indels.vcf \
    --mask-extension 5 \
    --mask-name InDel \
    -O ${OUTDIR}/genotyped_samples_snps_filtered.vcf \
    --cluster-window-size 10 \
    --filter-expression "QUAL < 30.0" \
    --filter-name "LowQuality" \
    --filter-expression "QD < 4.0" \
    --filter-name "QualByDepth" \
    --filter-expression "MQ < 40.0" \
    --filter-name "RMSMappingQuality" \
    --filter-name "SOR_filter" \
    --filter-expression "SOR > 10.0"

# Filter variants according to filter expression: INDEL
gatk VariantFiltration \
     -R ${REFERENCE} \
     -V ${OUTDIR}/genotyped_samples_indels.vcf \
     -O ${OUTDIR}/genotyped_samples_indels_filtered.vcf \
     -filter-name "QD_filter" \
     -filter-expression "QD < 2.0" \
     -filter-name "SOR_filter" \
     -filter-expression "SOR > 10.0" \
     -filter-name "LowQual_filter" \
     -filter-expression "QUAL < 30.0"
	
# Exclude filtered variants to get only the variants that PASSED the filtering as the input for the BaseRecalibration (BQSR) tool later on because it will ignore the "failed" status of the data
gatk SelectVariants \
    --exclude-filtered true \
    -V $OUTDIR/genotyped_samples_snps_filtered.vcf \
    -O $OUTDIR/bqsr_snps.vcf

gatk SelectVariants \
    --exclude-filtered true \
    -V $OUTDIR/genotyped_samples_indels_filtered.vcf \
    -O $OUTDIR/bqsr_indels.vcf
