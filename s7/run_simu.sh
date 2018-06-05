#/bin/bash -l
## run estomp simulation for mulitple realizations
## base case: case without water application
## r* cases: realizatons
## l* cases: addtional realizations with more frequent snapshot file output
## written by Xuehang Song 03/03/2018
## revised by Xuehang Song 04/08/2018

simu_dir="/pic/scratch/song884/fy2018/s7_4b/"
script_dir="/people/song884/stomp/tools/"

cd $simu_dir

for icase in base
do
    echo $icase
    cd $icase
    sbatch $script_dir"sbatch_stomp.sh"
    cd ../
done

for icase in $(ls -d *l*/)
do
    echo $icase
    cd $icase
     sbatch $script_dir"sbatch_stomp.sh"
    cd ../
done

for icase in $(ls -d *r*/)
do
    echo $icase
    cd $icase
    sbatch $script_dir"sbatch_stomp.sh"
    cd ../
done
