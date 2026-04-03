#!/bin/bash

set -euo pipefail

id_17a=$(sbatch 17a_final_haplotyping.sh | awk '{print $4}')
id_17b=$(sbatch --dependency=afterok:${id_17a} 17b_final_genotyping.sh | awk '{print $4}')
id_17c=$(sbatch --dependency=afterok:${id_17b} 17c_final_hardfiltering.sh | awk '{print $4}')

echo "Submitted iterative SNP pipeline."
echo "17a_haplotyping   : $id_17a"
echo "17b_genotyping    : $id_17b"
echo "17c_hardfiltering : $id_17c"
