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

INPUT_BAM="${OUTDIR}/${SAMPLE}_recal1.bams"
OUTPUT_GVCF="${OUTDIR}/${SAMPLE}_recal1.g.vcf"

# variant calling on recal1 files
gatk HaplotypeCaller \
    -R ${REFERENCE} \
    -I ${INPUT_BAM} \
    -O ${OUTPUT_GVCF} \
    --emit-ref-confidence GVCF \
    --contamination-fraction-to-filter 0.0002 \
    --min-base-quality-score 20 \
    --phred-scaled-global-read-mismapping-rate 30 \
    --standard-min-confidence-threshold-for-calling 40.0
