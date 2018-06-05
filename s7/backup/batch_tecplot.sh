#!/bin/bash -l

simu_dir="/pic/scratch/song884/fy2018/s7_1a7/"
tools_dir="/people/song884/stomp/tools/"
scripts_dir="/people/song884/dust/fy2018/s7_1a7/scripts/"
figures_dir="/people/song884/dust/fy2018/s7_1a7/figures/"


layouts=(
    $scripts_dir"s7_1a7_i129_slice_with_layer.lay"    
    $scripts_dir"s7_1a7_satu_slice_with_layer.lay"
)
layer=$scripts_dir"layer.dat"

cd $simu_dir
for icase in base
#for icase in $(ls -d *l*/)
do
    cd $simu_dir$icase"/tec_data"

    if [ ! -d $figures_dir$icase/ ] ; then
	mkdir $figures_dir$icase/
    else
	rm $figures_dir$icase/*
    fi    



    for ilayout in ${layouts[@]}
    do
	echo $ilayout
	fig_prefix=$(echo $ilayout |rev| cut -d "/" -f 1|rev|cut -d "." -f 1)
	for iplt in $(ls -rt *plt)
	do
	    echo $iplt 
	    itime=$(echo $iplt | cut -d "." -f 1-2)
	    ifig=$figures_dir$icase/$fig_prefix"_"$itime.jpg
	    iplt=$simu_dir$icase"/tec_data/"$iplt

	    solutiontime="  SOLUTIONTIME = "$itime
	    sed -i "/$!GLOBALTIME/!b;n;c\ $solutiontime" $ilayout

	    mcr_layout="\$!OPENLAYOUT = \"$ilayout\""
	    sed -i "/$!OPENLAYOUT/c\\$mcr_layout" \
	     	$scripts_dir"tecplot.mcr"

	    mcr_data="ALTDATALOADINSTRUCTIONS = '\"$iplt\" \"$layer\"'"
	    echo $mcr_data
	    sed -i "/ALTDATALOADINSTRUCTIONS/c\\$mcr_data" \
	      	$scripts_dir"tecplot.mcr"

	    mcr_fig="\$!EXPORTSETUP EXPORTFNAME = \"$ifig\""
	    echo $mcr_fig
	    sed -i "/EXPORTFNAME/c\\$mcr_fig" \
	       	$scripts_dir"tecplot.mcr"
	    
	    tec360 -b -p $scripts_dir"tecplot.mcr"
	done
    done
done    
# convert -delay 1 -loop 1 \
    # 	$(ls -rt $figures_dir$icase/i129_slice_*.jpg) \
    # 	$figures_dir$icase/i129_slice.gif

