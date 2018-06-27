## scripts was named as <solute.flux.v3.R>
## plot all figures for single case
## written by Xuehang 04/11/2018

rm(list=ls())
library(RColorBrewer)

case.dirs = c("by_2a",
               "by_1a",
               "by_4a",              
               "by_5a",
               "by_3a")


scripts.dir="/people/song884/github/dvz_dust/by/"

## parameters used to generate plots
solute.index = 6
wt.flux.index = 4

for (idir in case.)
{
    simu.dir=paste("/pic/scratch/song884/dust/fy2018/",
                   icase,"/",sep="")
    spinup.data = read.table(
    paste(simu.dir,icase,"/tec_data/surface.dat",sep=""),
    skip=3)
}
