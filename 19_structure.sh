#!/bin/bash
#SBATCH --time=12:00:00
#SBATCH --cpus-per-task=1
#SBATCH --mem=4G
#SBATCH --array=0-159

module load structure/2.3.4

# --- settings ---
K_MIN=1
K_MAX=8
REPS=20

# Map array index -> K and replicate
K=$(( K_MIN + SLURM_ARRAY_TASK_ID / REPS ))
REP=$(( 1 + SLURM_ARRAY_TASK_ID % REPS ))

cd /shared/projects/daunpapua/Isidoides/uce/structure

OUTPREFIX="results/K${K}_rep${REP}"

echo "Running STRUCTURE with K=${K}, replicate=${REP}"
echo "Task ID: ${TASK_ID}"
echo "Output prefix: ${OUTPREFIX}"

structure \
    -m params/mainparams \
    -e params/extraparams \
    -K "${K}" \
    -o "${OUTPREFIX}"

echo "Done: K=${K}, replicate=${REP}"
