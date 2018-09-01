#!/bin/bash -l

simu_dir="./"
tools_dir="/people/song884/github/constance_tools/"

if [ ! -d tec_data ]
then
    mkdir tec_data
fi

cases=$(cd $simu_dir && ls -d */)

cd $simu_dir

for icase in $cases
do
    echo $icase
    cd $icase
    bash $tools_dir"convert_output_surface.sh" > output.log 
    cd ../
done

