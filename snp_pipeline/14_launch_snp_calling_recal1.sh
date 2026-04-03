#!/bin/bash

set -euo pipefail

id_14a=$(sbatch 14a_haplotyping_recal1.sh | awk '{print $4}')
id_14b=$(sbatch --dependency=afterok:${id_14a} 14b_genotyping_recal1.sh | awk '{print $4}')
id_14c=$(sbatch --dependency=afterok:${id_14b} 14c_hardfiltering_recal1.sh | awk '{print $4}')

echo "Submitted iterative SNP pipeline."
echo "14a_haplotyping   : $id_14a"
echo "14b_genotyping    : $id_14b"
echo "14c_hardfiltering : $id_14c"
