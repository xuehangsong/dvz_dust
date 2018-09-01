#!/bin/bash -l

group="s7_6a"
simu_dir="/pic/projects/dvz/xhs_simus/dust/fy18/"$group/


simu_dir="./"
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
    bash $tools_dir"convert_output_surface.sh" > output.log
    cd ../
done

