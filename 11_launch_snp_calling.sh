#!/bin/bash

set -euo pipefail

id_11a=$(sbatch 11a_haplotyping.sh | awk '{print $4}')
id_11b=$(sbatch --dependency=afterok:${id_11a} 11b_genotyping.sh | awk '{print $4}')
id_11c=$(sbatch --dependency=afterok:${id_11b} 11c_hardfiltering.sh | awk '{print $4}')

echo "Submitted iterative SNP pipeline."
echo "11a_haplotyping   : $id_11a"
echo "11b_genotyping    : $id_11b"
echo "11c_hardfiltering : $id_11c"
