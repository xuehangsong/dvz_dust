#!/bin/bash -l
#SBATCH -A dvz
#SBATCH -t 03:00:00
#SBATCH -p short
#SBATCH -N 1
#SBATCH -n 24
#SBATCH -J tecplot
#SBATCH --exclusive
#SBATCH --mail-type=ALL
#SBATCH --mail-user=xuehang.song@pnnl.gov

case_name="s7_4a"

reazs=$(cd "/pic/scratch/song884/fy2018/"$case_name"/" && ls -d *l*/)
#reazs=base
reazs=2018_l

scripts_dir="/people/song884/dust/fy2018/s7_1a/scripts/"

for ireaz in $reazs
do
    export data_dir="/pic/scratch/song884/fy2018/"$case_name"/"$ireaz"/tec_data/"
    export fig_dir="/people/song884/dust/fy2018/"$case_name"/figures/"$ireaz"/"
    export scripts_dir

    sh $scripts_dir"s7_tecplot.sh" &
done

wait
