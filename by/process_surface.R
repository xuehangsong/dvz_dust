## scripts was named as <solute.flux.v3.R>
## plot all figures for single case
## written by Xuehang 04/11/2018

rm(list=ls())
library(RColorBrewer)

#simu.dir="/pic/projects/dvz/xhs_simus/dust/fy18/by_9a/"
simu.dir="./"


scripts.dir="/people/song884/github/dvz_dust/by/"
# load model parameters
source(paste(scripts.dir,"parameter.R",sep=""))

## list all cases files
cases = c(list.files(paste(simu.dir,sep=""),pattern="^r"),
          list.files(paste(simu.dir,sep=""),pattern="^l"),
          list.files(paste(simu.dir,sep=""),pattern="^2018$"),
          list.files(paste(simu.dir,sep=""),pattern="^base$"))

## read the surface data from 
surface.data = list()
for (icase in cases)
{
    print(icase)
    case.data = read.table(
        paste(simu.dir,icase,"/tec_data/surface.dat",sep=""),
        skip=3)
    surface.data[[icase]] = case.data[,c(1,4,6)]
    colnames(surface.data[[icase]]) = c("time",
                                        "crib.water",
                                        "crib.solute")
                                        
}

save(surface.data,file=paste(simu.dir,"surface_data.r",sep=""))
