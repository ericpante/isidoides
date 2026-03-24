#!/bin/bash

#SBATCH --cpus-per-task=16
#SBATCH --mem=16G
#SBATCH --time=00:30:00
#SBATCH --array=1-21

# follows Erickson_etal_2021_Sinularia_Alcyonium_SNP_Calling_Pipeline Code.docx
# this script is based on 1a_0_bwa_mapping_loop.sh from https://github.com/zarzamora23/SNPs_from_UCEs
# and on https://github.com/Lavarchus/SNP-calling-GATK4/blob/main/snp_calling_GATK4.sh
module load bwa-mem2/2.2.1
module load samtools/1.21
module load picard/2.23.5

# indexing contigs database from ref individual
cd /shared/projects/daunpapua/Isidoides/uce/snp_calling
#bwa-mem2 index -p contigs /shared/projects/daunpapua/Isidoides/uce/snp_calling/ref-ONLY-UCE.fasta

READS_FOLDER=/shared/projects/daunpapua/Isidoides/uce/clean-fastq/links
config=/shared/projects/daunpapua/Isidoides/uce/bwa.config
SAMPLE_NAME=$(awk -v ArrayTaskID=$SLURM_ARRAY_TASK_ID '$1==ArrayTaskID {print$2}' $config)
read1=$(awk -v ArrayTaskID=$SLURM_ARRAY_TASK_ID '$1==ArrayTaskID {print$3}' $config)
read2=$(awk -v ArrayTaskID=$SLURM_ARRAY_TASK_ID '$1==ArrayTaskID {print$4}' $config)
read_singleton=$(awk -v ArrayTaskID=$SLURM_ARRAY_TASK_ID '$1==ArrayTaskID {print$5}' $config)

#  map reads
bwa-mem2 mem -t $SLURM_CPUS_PER_TASK \
	 -B 10 -M -R "@RG\tID:$SAMPLE_NAME\tSM:$SAMPLE_NAME\tPL:Illumina" \
	 contigs \
	 $READS_FOLDER/$read1 $READS_FOLDER/$read2 \
	 > $SAMPLE_NAME.pair.sam

bwa-mem2 mem -t $SLURM_CPUS_PER_TASK \
         -B 10 -M -R "@RG\tID:$SAMPLE_NAME\tSM:$SAMPLE_NAME\tPL:Illumina" \
         contigs \
         $READS_FOLDER/$read_singleton \
         > $SAMPLE_NAME.single.sam

# sort reads and remove unmapped reads
samtools view -bS -F 4 $SAMPLE_NAME.pair.sam   | samtools sort -@ $SLURM_CPUS_PER_TASK -o $SAMPLE_NAME.pair_sorted.bam
samtools view -bS -F 4 $SAMPLE_NAME.single.sam | samtools sort -@ $SLURM_CPUS_PER_TASK -o $SAMPLE_NAME.single_sorted.bam

# mark duplicates
picard MarkDuplicates \
       INPUT=$SAMPLE_NAME.pair_sorted.bam \
       INPUT=$SAMPLE_NAME.single_sorted.bam \
       OUTPUT=$SAMPLE_NAME.All_dedup.bam \
       METRICS_FILE=$SAMPLE_NAME.All_dedup_metricsfile \
       MAX_FILE_HANDLES_FOR_READ_ENDS_MAP=250 \
       ASSUME_SORTED=true \
       VALIDATION_STRINGENCY=SILENT \
       REMOVE_DUPLICATES=True

# index bam file
picard BuildBamIndex INPUT=$SAMPLE_NAME.All_dedup.bam
samtools flagstat $SAMPLE_NAME.All_dedup.bam > $SAMPLE_NAME.All_dedup_stats.txt

#get stats only for paired files before removing duplicates
samtools flagstat $SAMPLE_NAME.pair_sorted.bam > $SAMPLE_NAME.pair_stats.txt

# tidying up :-) 
rm $SAMPLE_NAME.pair.sam
rm $SAMPLE_NAME.single.sam 
rm $SAMPLE_NAME.pair_sorted.bam
rm $SAMPLE_NAME.single_sorted.bam
