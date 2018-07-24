#!/bin/bash -l
#SBATCH -A dvz
#SBATCH -t 7-00:00:00
#SBATCH -p slurm
#SBATCH -N 20
#SBATCH -J estomp
#SBATCH --exclusive
#SBATCH --mail-type=ALL
#SBATCH --mail-user=xuehang.song@pnnl.gov

## run estomp simulation for mulitple realizations
## base case: case without water application
## r* cases: realizatons
## l* cases: addtional realizations with more frequent snapshot file output
## written by Xuehang Song 03/03/2018
## revised by Xuehang Song 07/20/2018


source /people/song884/stomp/tools/stomp_envi.sh

##rm plot* restart* slurm* stomp* batch* surface* output*
###rm input ; ln -s input* input

#Is extremely useful to record the modules you have loaded, your limit settings, 
#your current environment variables and the dynamically load libraries that your executable 
# #is linked against in your job output file.
echo
echo "loaded modules"
echo
module list >& _modules.lis_
cat _modules.lis_
/bin/rm -f _modules.lis_
echo
echo "Environment Variables"
echo
printenv
echo
echo "ldd output"
echo




simu_dir="/pic/scratch/song884/dust/fy2018/s7_6a/"

cd $simu_dir

for icase in base
do
    echo $icase
    cd $icase
        mpirun -n 24 /people/song884/stomp/bin/eSTOMP1_503.x > ./stomp.out &
    cd ../
done

for icase in $(ls -d *l*/)
do
    echo $icase
    cd $icase
        mpirun -n 24 /people/song884/stomp/bin/eSTOMP1_503.x  > ./stomp.out &
    cd ../
done

for icase in $(ls -d *r*/)
do
    echo $icase
    cd $icase
        mpirun -n 24 /people/song884/stomp/bin/eSTOMP1_503.x  > ./stomp.out &
    cd ../
done

wait
