#!/bin/bash -l

group="by_4a"


simu_dir="/pic/scratch/song884/dust/fy2018/"$group/
tools_dir="/people/song884/github/constance_tools/"

if [ ! -d tec_data ]
then
    mkdir tec_data
fi

cases=$(cd $simu_dir && ls -d */)
for icase in $cases
do
    echo $icase
    cd $simu_dir$icase
    bash $tools_dir"convert_output_surface.sh" > output.log &    
done


