#/bin/bash -l

## use estomp /perl/ postprocess scritps
## to do initial postprocess of modeling results

## r* cases: realizatons
## l* cases: addtional realizations with more frequent snapshot file output
## written by Xuehang Song 03/03/2018
## revised by Xuehang Song 04/10/2018


simu_dir="/pic/scratch/song884/dust/fy2018/s7_5b/"
script_dir="/people/song884/stomp/tools/"

cd $simu_dir


for icase in ss
do
    echo $icase
    cd $icase
    sbatch $script_dir"sbatch_postprocess.sh"
    cd ../
done

for icase in 2018
do
    echo $icase
    cd $icase
    sbatch $script_dir"sbatch_postprocess.sh"
    cd ../
done


for icase in base
do
    echo $icase
    cd $icase
    sbatch $script_dir"sbatch_postprocess.sh"
    cd ../
done


for icase in $(ls -d *l*/)	     
do
    echo $icase
    cd $icase
    sbatch $script_dir"sbatch_postprocess.sh"
    cd ../
done


for icase in $(ls -d *r*/)	     
do
    echo $icase
    cd $icase
    sbatch $script_dir"sbatch_postprocess.sh"
    cd ../
done
