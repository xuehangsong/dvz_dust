#!/bin/bash  -l
#SBATCH -A dvz
#SBATCH -t 01:00:00
#SBATCH -p shared
#SBATCH -n 1
#SBATCH -N 1
#SBATCH -J conc
#SBATCH --mail-type=ALL
#SBATCH --mail-user=xuehang.song@pnnl.gov

ulimit -s unlimited
module load R/3.3.3

Rscript /people/song884/github/dvz_dust/s7/process_conc.R
#Rscript /people/song884/github/dvz_dust/s7/process_surface.R 
