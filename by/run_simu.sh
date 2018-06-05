#/bin/bash -l
simu_dir="/pic/scratch/song884/dust/fy2018/by_3a/"
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
