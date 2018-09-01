#!/bin/bash -l
group="by_10a"

simu_dir="/pic/projects/dvz/xhs_simus/dust/fy18/"$group/
figures_dir="/people/song884/dust/fy18/"$group"/figures/"

tools_dir="/people/song884/github/constance_tools/"
scripts_dir="/people/song884/github/dvz_dust/by/"

layouts="by_no3_with_layer_v2.lay
	 by_satu_with_layer_v2.lay
	 by_no3_with_layer.lay
	 by_satu_with_layer.lay"


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
