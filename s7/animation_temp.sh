#!/bin/bash -l

## use results from batch_tecplot.sh
## generate animations from tecplot output

## written by Xuehang Song 03/01/2018
## revised by Xuehang Song 04/13/2018


simu_dir="/pic/scratch/song884/fy2018/s7_4b/"
figures_dir="/people/song884/dust/fy2018/s7_4b/figures/"


scripts_dir="/people/song884/dust/fy2018/s7_4a/scripts/"

min_time=2018
max_time=2200

layouts=($scripts_dir"s7_i129_slice_with_layer.lay"
	 $scripts_dir"s7_satu_slice_with_layer.lay"
	)

cd $simu_dir

cases=("base" $(ls -d *l*))
for icase in ${cases[@]}
do
    echo $icase
    selected_figs=()
    i=0
    for ilayout in ${layouts[@]}
    do
	fig_prefix=$(echo $ilayout |rev| cut -d "/" -f 1|rev|cut -d "." -f 1)
	echo $fig_prefix
	for ifig in $(ls -rt $figures_dir$icase/$fig_prefix*jpg)
	do
    	    itime=$(echo $ifig |rev|cut -d "_" -f 1|rev|cut -d "." -f 1-2)

	    if [ $(echo "$itime <= $max_time" | bc -l) -eq 1 ] &&
		   [ $(echo "$itime >= $min_time" | bc -l) -eq 1 ]; then
		echo $itime
		selected_figs[$i]=$ifig
		echo $i
		#	    selected_figs=$selected_figs" "
		i=$(($i+1))
            fi

	done
	echo ${selected_figs[@]}
	convert -delay 20 -loop 0 \
		${selected_figs[@]} \
    		$figures_dir$icase/$fig_prefix.gif
	selected_figs=()
    done    

done    

