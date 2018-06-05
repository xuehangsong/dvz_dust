#!/bin/bash -l
#SBATCH -A dvz
#SBATCH -t 03:00:00
#SBATCH -p slurm
#SBATCH -N 1
#SBATCH -n 24
#SBATCH -J tecplot
#SBATCH --exclusive
#SBATCH --mail-type=ALL
#SBATCH --mail-user=xuehang.song@pnnl.gov


simu_dir="/pic/scratch/song884/fy2018/by_1a/"
tools_dir="/people/song884/stomp/tools/"
scripts_dir="/people/song884/dust/fy2018/by_1a/scripts/"
figures_dir="/people/song884/dust/fy2018/by_1a/figures/"

export simu_dir
export tools_dir
export scripts_dir
export figures_dir

cases=$(cd "/pic/scratch/song884/fy2018/by_1a/" && ls -d *l*/)


for icase in $cases
do
    export icase
    sh $scripts_dir"batch_tecplot.sh" &
done

wait
