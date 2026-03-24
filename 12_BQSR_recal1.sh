#!/bin/bash

#SBATCH --cpus-per-task=4
#SBATCH --mem=16G
#SBATCH --time=12:00:00
#SBATCH --array=1-21

# follows Erickson_etal_2021_Sinularia_Alcyonium_SNP_Calling_Pipeline Code.docx
# this script is based on 2_indelrealigner-WLET_copy.sh from https://github.com/zarzamora23/SNPs_from_UCEs
# and on https://github.com/Lavarchus/SNP-calling-GATK4/blob/main/snp_calling_GATK4.sh

module load gatk4/4.6.1.0

RUNDIR=/shared/projects/daunpapua/Isidoides/uce
OUTDIR=/shared/projects/daunpapua/Isidoides/uce/snp_calling
cd $OUTDIR

CONFIG="$RUNDIR/snp.config"
SAMPLE=$(awk -v ArrayTaskID=$SLURM_ARRAY_TASK_ID '$1==ArrayTaskID {print$2}' $CONFIG)
REFERENCE="$OUTDIR/ref-ONLY-UCE.fasta"

INPUT_SUFFIX="_realigned.bam"
INPUT_BAM="${OUTDIR}/${SAMPLE}${INPUT_SUFFIX}"

# 1ST RECALIBRATION 
# Run BaseRecalibrator on the orignial bam files to get the recal table with the original base scores.

gatk BaseRecalibrator \
    -R ${REFERENCE} \
    -I ${INPUT_BAM} \
    --known-sites ${OUTDIR}/bqsr_snps.vcf \
    --known-sites ${OUTDIR}/bqsr_indels.vcf \
    -O ${OUTDIR}/${SAMPLE}_pre_recal1.table

# Run ApplyBQSR with the recal table from last step to create a new bam file with the adjusted base quality scores

gatk ApplyBQSR \
    -R ${REFERENCE} \
    -I ${INPUT_BAM} \
    --bqsr-recal-file ${OUTDIR}/${SAMPLE}_pre_recal1.table \
    -O ${OUTDIR}/${SAMPLE}_recal1.bams

# Run BaseRecalibrator on the adjusted bam files in last step to create a new
# recal table with the adjusted base quality scores and be able to plot before/after 1st recalibration. 

gatk BaseRecalibrator \
    -R ${REFERENCE} \
    -I ${OUTDIR}/${SAMPLE}_recal1.bams \
    --known-sites ${OUTDIR}/bqsr_snps.vcf \
    --known-sites ${OUTDIR}/bqsr_indels.vcf \
    -O ${OUTDIR}/${SAMPLE}_post_recal1.table
