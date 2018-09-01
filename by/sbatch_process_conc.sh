#!/bin/bash  -l
#SBATCH -A dvz
#SBATCH -t 24:00:00
#SBATCH -p shared
#SBATCH -n 2
#SBATCH -N 1
#SBATCH -J conc
#SBATCH --mail-type=ALL
#SBATCH --mail-user=xuehang.song@pnnl.gov

ulimit -s unlimited
module load R/3.3.3

Rscript /people/song884/github/dvz_dust/by/process_conc.R 
#Rscript /people/song884/github/dvz_dust/by/process_surface.R 
