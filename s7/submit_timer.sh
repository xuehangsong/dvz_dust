#!/bin/bash -l

sleep 4800

sh run_post.sh

sleep 4800

sbatch sbatch_tecplot.sh
sh animation.sh &

sleep 4800
sh run_post.sh

sleep 4800
sh animation_temp.sh &
Rscript plot_single_case.R
Rscript plot_multi_cases.R 
##sh run_simu.sh


wait
