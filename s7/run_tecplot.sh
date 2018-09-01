#!/bin/bash -l
group="s7_3b"

simu_dir="/pic/projects/dvz/xhs_simus/dust/fy18/"$group/
figures_dir="/people/song884/dust/fy18/"$group"/figures/"

tools_dir="/people/song884/github/constance_tools/"
scripts_dir="/people/song884/github/dvz_dust/s7/"

layouts="s7_i129_slice_with_layer.lay
	s7_satu_slice_with_layer.lay"


cases=$(cd $simu_dir && ls -d *l*/)

export tools_dir=$tools_dir
export scripts_dir=$scripts_dir
export simu_dir=$simu_dir
export layouts=$layouts
export cases=$cases
export figures_dir=$figures_dir

for icase in $cases base ss 2018
do
    export icase=$icase
    sbatch $scripts_dir"batch_tecplot.sh" 
done
