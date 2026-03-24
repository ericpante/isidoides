#!/bin/bash

#SBATCH --cpus-per-task=4
#SBATCH --mem=16G
#SBATCH --time=12:00:00
#SBATCH --array=1-21

# follows Erickson_etal_2021_Sinularia_Alcyonium_SNP_Calling_Pipeline Code.docx
# this script is based on 2_indelrealigner-WLET_copy.sh from https://github.com/zarzamora23/SNPs_from_UCEs
# and on https://github.com/Lavarchus/SNP-calling-GATK4/blob/main/snp_calling_GATK4.sh

module load gatk4/4.6.1.0
module load r/4.5.2

RUNDIR=/shared/projects/daunpapua/Isidoides/uce
OUTDIR=/shared/projects/daunpapua/Isidoides/uce/snp_calling
cd $OUTDIR

CONFIG="$RUNDIR/snp.config"
SAMPLE=$(awk -v ArrayTaskID=$SLURM_ARRAY_TASK_ID '$1==ArrayTaskID {print$2}' $CONFIG)
REFERENCE="$OUTDIR/ref-ONLY-UCE.fasta"

# Before/After recalibration plots to see how the first recalibration worked out on
# the original data. You want to look for convergence. If it converges you can go
# ahead into a "true" variant calling run and call on the recalibrated bam files.
# If results aren't converging, you'll need to bootstrap your data by repeating all
# the steps from HaplotypeCaller on the unrecalibrated data until the plots show
#convergence (usually 2-4 times).

# R packages that needs to be installed for AnalyzeCovariates: gsalib, ggplot2

gatk AnalyzeCovariates \
    -before ${OUTDIR}/${SAMPLE}_post_recal1.table \
    -after ${OUTDIR}/${SAMPLE}_post_recal2.table \
    -plots ${OUTDIR}/${SAMPLE}_recalibration_plot_recal2.pdf
