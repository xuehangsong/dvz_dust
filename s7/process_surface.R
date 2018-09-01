## scripts was named as <solute.flux.v3.R>
## plot all figures for single case
## written by Xuehang 04/11/2018


## # Below the dust control zone
## #
## Aqueous Volumetric Flux,L/yr,m^3,top,   27,37,61,65,83,83,  # Fluxe across ground surface
## Aqueous Volumetric Flux,L/yr,m^3,bottom,27,37,61,65,17,17,  # Fluxe entering water table
## Solute Flux,I-129,         1/yr,,bottom,27,37,61,65,17,17,  
## #
## # Below the simulation domain
## #
## Aqueous Volumetric Flux,L/yr,m^3,top,   1,110,1,65,83,83,  # Fluxe across ground surface
## Aqueous Volumetric Flux,L/yr,m^3,bottom,1,110,1,65,17,17,  # Fluxe entering water table
## Solute Flux,I-129,         1/yr,,bottom,1,110,1,65,17,17,  
## #
## # At the downstream of GW (GW is from west to east)
## Aqueous Volumetric Flux,L/yr,m^3,east,  37,37,61,65,1,17, # dust zone
## Aqueous Volumetric Flux,L/yr,m^3,east,   1, 1, 1,65,1,17,

#-------------output file index------------
###1 -- "Aqueous Volumetric Flux, l/yr, m^3"  
###2 -- "Aqueous Volumetric Flux, l/yr, m^3"  
###3 -- "Solute Flux (i-129), 1/yr, sol"
###4 -- "Aqueous Volumetric Flux, l/yr, m^3"
###5 -- "Aqueous Volumetric Flux, l/yr, m^3"
###6 -- "Solute Flux (i-129), 1/yr, sol"
###7 -- "Aqueous Volumetric Flux, l/yr, m^3"
###8 -- "Aqueous Volumetric Flux, l/yr, m^3"

rm(list=ls())
library(RColorBrewer)

#simu.dir="/pic/projects/dvz/xhs_simus/dust/fy18/s7_9a/"
simu.dir="./"
scripts.dir="/people/song884/github/dvz_dust/s7/"


scripts.dir="/people/song884/github/dvz_dust/s7/"
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
    surface.data[[icase]] = case.data[,c(1,4,6,10,12)]
    colnames(surface.data[[icase]]) = c("time",
                                        "crib.water",
                                        "crib.solute",
                                        "domain.water",
                                        "domain.solute")
                                        
}

save(surface.data,file=paste(simu.dir,"surface_data.r",sep=""))

## ## parameters used to generate plots
## i129.index = 6
## wt.flux.index = 4

## save(list=ls(),file=paste(results.dir,"results.r",sep=""))
