#!/bin/bash

#SBATCH --cpus-per-task=16
#SBATCH --mem=16G
#SBATCH --time=01:00:00

# follows Erickson_etal_2021_Sinularia_Alcyonium_SNP_Calling_Pipeline Code.docx
module load phyluce/1.7.3 

# make sym links into "links" folder 
cd /shared/projects/daunpapua/Isidoides/uce/clean-fastq
mkdir ./links

for d in Isidoides*/split-adapter-quality-trimmed; do            # loops over the trimming subdirectory inside every Isidoides* folder.
    for f in "$d"/*.fastq.gz; do  # loops over all fastq.gz files in that subdirector
        [ -e "$f" ] || continue   # skips directories with no FASTQ files.
        ln -sfn "$(readlink -f "$f")" "links/$(basename "$f")"   # creates a symlink in links/ using the original filename
    done
done

