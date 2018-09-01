#!/bin/bash -l
#SBATCH -A dvz
#SBATCH -t 03:00:00
#SBATCH -p short
#SBATCH -N 1
#SBATCH -J tec2r
#SBATCH --mail-type=ALL
#SBATCH --mail-user=xuehang.song@pnnl.gov


module purge 
module load R/3.3.3

Rscript /people/song884/github/dvz_dust/parallel_tec2r.R
