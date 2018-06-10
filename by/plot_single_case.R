## scripts was named as <solute.flux.v3.R>
## plot all figures for single case
## written by Xuehang 04/11/2018

rm(list=ls())
library(RColorBrewer)


case.name = "by_3a"


## define dirs
simu.dir=paste("/pic/scratch/song884/dust/fy2018/",
               case.name,"/",sep="")
figure.dir=paste("/people/song884/dust/fy2018/",
                 case.name,"/figures/",sep="")
results.dir = paste("/people/song884/dust/fy2018/",
                    case.name,"/",sep="")


scripts.dir="/people/song884/github/dvz_dust/by/"
## read parameters
source(paste(scripts.dir,"parameter.R",sep=""))
 
## parameters used to generate plots
solute.index = 6
wt.flux.index = 4
colors = rev(topo.colors(ncase))
colors = rainbow(ncase,end=0.65)
names(colors) = cases
rate.at = seq(0,500,100)
truckload.at = seq(0,80,20)*15.14165*1000/crib.area
truckload.label = seq(0,5,40)
year.at = seq(2010,2100,2)
solute.at = seq(0,3000000,500000)
lengend.index = c(1,seq(50,500,50))

## read model spin up data
icase="2018"
spinup.data = read.table(
    paste(simu.dir,icase,"/tec_data/surface.dat",sep=""),
    skip=3)

## find the peak year and peak flux of  solute entering the saturated zone
surface.data = list()
peak.solute = rep(NA,1+ncase)
names(peak.solute) = c("base",cases)
peak.year = rep(NA,1+ncase)
names(peak.year) = c("base",cases)
for (icase in c("base",cases))
{
    print(icase)
    case.data = read.table(
        paste(simu.dir,icase,"/tec_data/surface.dat",sep=""),
        skip=3)
    peak.solute[icase] = max(case.data[,solute.index])/crib.area
    peak.year[icase] = case.data[which.max(case.data[,solute.index]),1]
    surface.data[[icase]] = rbind(spinup.data,case.data)
    
}

## find when system return to natural status (equilibration)
equi.solute.value = 0.
equi.wt.value =  tail(surface.data[["base"]][,wt.flux.index],1)
equi.solute.year = rep(NA,1+ncase)
equi.wt.year = rep(NA,1+ncase)
names(equi.wt.year) = c("base",cases)
names(equi.solute.year) = c("base",cases)

interp.t = seq(2018,3000,0.01)
equi.wt.value = approx(surface.data[["base"]][,1],
                       surface.data[["base"]][,wt.flux.index],
                       interp.t)[[2]]

equi.solute.value = approx(surface.data[["base"]][,1],
                       surface.data[["base"]][,solute.index],
                       interp.t)[[2]]

equi.wt.value = tail(surface.data[["base"]][,wt.flux.index],1)
equi.solute.value = 1#tail(surface.data[["base"]][,solute.index],1)

for (icase in c(cases))
{
    print(icase)

    interp.wt = approx(surface.data[[icase]][,1],
                       surface.data[[icase]][,wt.flux.index],
                       interp.t)[[2]]
    interp.solute = approx(surface.data[[icase]][,1],
                       surface.data[[icase]][,solute.index],
                       interp.t)[[2]]
    
    equi.index = which(abs(interp.wt-equi.wt.value)/equi.wt.value>1)
    equi.index = tail(equi.index,1)+1
    equi.wt.year[icase] = interp.t[equi.index]

    equi.index = which(abs(interp.solute-equi.solute.value)/equi.solute.value>1)
    equi.index = tail(equi.index,1)+1
    equi.solute.year[icase] = interp.t[equi.index]
}
#equi.wt.year["r116"] = 0.5*(equi.wt.year["r114"]+equi.wt.year["r118"])


save(list=ls(),file=paste(results.dir,"results.r",sep=""))

stop()



## plot peak year of solute flux
jpeg(filename=paste(figure.dir,"peak_year.jpg",sep=""),
     width = 6.5,height = 5,
     units = "in",res = 600, quality = 100)
par(mgp=c(2.,0.,0),
    mar=c(5.0,2.4,2.4,0.5),
    oma=c(0,0,0,0))
plot(c(0,rate),peak.year,
     type="l",
     lwd=1,
     lty=1,
     pch=1,
     col="white",
     xlab=NA,
     ylab=NA,
     ylim=c(2018,2030),
     axes=FALSE,
     )
box()
points(0,peak.year[1],pch=1)
lines(c(rate),peak.year[-1])
points(c(rate),peak.year[-1],pch=1,col="red")
axis(1,at=rate.at,labels=rate.at,tck=0.02)
axis(2,at=year.at,labels=year.at,tck=0.02)
axis(3,at=truckload.at,
     line=0,col="blue",col.ticks="blue",col.axis="blue",
     labels=sprintf("%1.1f",truckload.label),tck=0.02)
mtext("Water Application Rate (mm/day)",1,line=1)
axis(1,at=rate.at,line=2.7,col="blue",col.ticks="blue",col.axis="blue",
     labels=sprintf("%2.1f",rate.at*crib.area/1000*264.172/24/60),tck=0.02)
mtext(expression("Applied Water Volume (gal/min)"),
      1,line=4,col="blue")
mtext(expression("Truckloads/day (1 truck = 4000 gal)"),
      3,line=1,col="blue")
mtext("Time (year)",2,line=1)
dev.off()



## plot peak flux of solute
jpeg(filename=paste(figure.dir,"peak_flux.jpg",sep=""),
     width = 6.5,height = 5,
     units = "in",res = 600, quality = 100)
par(mgp=c(2.,0.,0),
    mar=c(5.0,2.4,2.4,0.5),    
    oma=c(0,0,0,0))
plot(c(0,rate),peak.solute,
     type="l",
     lwd=1,
     lty=1,
     pch=1,
     col="white",
     xlab=NA,
     ylab=NA,
     ylim=c(0,5e6),
     axes=FALSE,
     )
box()
lines(c(0,rate),peak.solute)
points(c(0,rate),peak.solute,col="red")
points(0,peak.solute[1],pch=1,col="black")
axis(1,at=rate.at,labels=rate.at,tck=0.02)
axis(2,tck=0.02)
## axis(2,at=solute.at,
##      labels=sprintf("%2.1e",solute.at),tck=0.02)
axis(3,at=truckload.at,
     line=0,col="blue",col.ticks="blue",col.axis="blue",
     labels=sprintf("%1.1f",truckload.label),tck=0.02)
axis(1,at=rate.at,line=2.7,col="blue",col.ticks="blue",col.axis="blue",
     labels=sprintf("%2.1f",rate.at*crib.area/1000*264.172/24/60),tck=0.02)
mtext("Water Application Rate (mm/day)",1,line=1)
mtext(expression("Applied Water Volume (gal/min)"),
      1,line=4,col="blue")
mtext(expression("Truckloads/day (1 truck = 4000 gal)"),
      3,line=1,col="blue")
mtext(expression("I-129 Flux Rate (pCi/yr/" ~ m^2 ~")"),
      2,line=1)
dev.off()

## plot solute flux scaled to solute flux of base case
jpeg(filename=paste(figure.dir,"peak_flux_scale.jpg",sep=""),
     width = 6.5,height = 5,
     units = "in",res = 600, quality = 100)
par(mgp=c(2.,0.,0),
    mar=c(5.0,2.4,2.4,0.5),    
    oma=c(0,0,0,0))
plot(c(0,rate),peak.solute/peak.solute[1],
     type="l",
     lwd=1,
     lty=1,
     pch=1,
     col="white",
     xlab=NA,
     ylab=NA,
     ylim=c(0,150),
     axes=FALSE,
     )
box()
lines(c(0,rate),peak.solute/peak.solute[1])
points(c(0,rate),peak.solute/peak.solute[1],col="red")
points(0,1,pch=1,col="black")
axis(1,at=rate.at,labels=rate.at,tck=0.02)
axis(2,tck=0.02)
## axis(2,at=solute.at,
##      labels=sprintf("%2.1e",solute.at),tck=0.02)
axis(3,at=truckload.at,
     line=0,col="blue",col.ticks="blue",col.axis="blue",
     labels=sprintf("%1.1f",truckload.label),tck=0.02)
axis(1,at=rate.at,line=2.7,col="blue",col.ticks="blue",col.axis="blue",
     labels=sprintf("%2.1f",rate.at*crib.area/1000*264.172/24/60),tck=0.02)
mtext("Water Application Rate (mm/day)",1,line=1)
mtext(expression("Applied Water Volume (gal/min)"),
      1,line=4,col="blue")
mtext(expression("Truckloads/day (1 truck = 4000 gal)"),
      3,line=1,col="blue")
mtext(expression("I-129 Flux Rate Normalized to Baseline (-)"),
      2,line=1)
dev.off()


## plot the equilibration year of water entering saturation zone
jpeg(filename=paste(figure.dir,"equal_wt_year.jpg",sep=""),
     width = 6.5,height = 4.5,
     units = "in",res = 600, quality = 100)
par(mgp=c(2.,0.,0),
    mar=c(5.0,2.4,2.4,0.5),    
    oma=c(0,0,0,0))
plot(c(0,rate),equi.wt.year,
     type="l",
     lwd=1,
     lty=1,
     pch=1,
     col="white",
     xlab=NA,
     ylab=NA,
     axes=FALSE,
     )
box()
lines(c(0,rate),equi.wt.year)
points(c(0,rate),equi.wt.year,col="red")
points(0,equi.wt.year[1],pch=1,col="black")
axis(1,at=rate.at,labels=rate.at,tck=0.02)
#axis(2,at=seq(2040,2100,10),tck=0.02)
axis(2,tck=0.02)
axis(3,at=truckload.at,
     line=0,col="blue",col.ticks="blue",col.axis="blue",
     labels=sprintf("%1.1f",truckload.label),tck=0.02)
axis(1,at=rate.at,line=2.7,col="blue",col.ticks="blue",col.axis="blue",
     labels=sprintf("%2.1f",rate.at*crib.area/1000*264.172/24/60),tck=0.02)
mtext("Water Application Rate (mm/day)",1,line=1)
mtext(expression("Applied Water Volume (gal/min)"),
      1,line=4,col="blue")
mtext(expression("Truckloads/day (1 truck = 4000 gal)"),
      3,line=1,col="blue")
mtext(expression("Equilibration Time (year)"),
      2,line=1)
dev.off()


## plot the equilibration year of solute entering saturation zone
jpeg(filename=paste(figure.dir,"equal_solute_year.jpg",sep=""),
     width = 6.5,height = 4.5,
     units = "in",res = 600, quality = 100)
par(mgp=c(2.,0.,0),
    mar=c(5.0,2.4,2.4,0.5),    
    oma=c(0,0,0,0))
plot(c(0,rate),equi.solute.year,
     type="l",
     lwd=1,
     lty=1,
     pch=1,
     col="white",
     xlab=NA,
     ylab=NA,
     axes=FALSE,
     ylim=c(2450,2550)
     )
box()
lines(c(0,rate),equi.solute.year)
points(c(0,rate),equi.solute.year,col="red")
points(0,equi.solute.year[1],pch=1,col="black")
axis(1,at=rate.at,labels=rate.at,tck=0.02)
#axis(2,at=seq(2000,3000,20),tck=0.02)
axis(2,tck=0.02)
axis(3,at=truckload.at,
     line=0,col="blue",col.ticks="blue",col.axis="blue",
     labels=sprintf("%1.1f",truckload.label),tck=0.02)
axis(1,at=rate.at,line=2.7,col="blue",col.ticks="blue",col.axis="blue",
     labels=sprintf("%2.1f",rate.at*crib.area/1000*264.172/24/60),tck=0.02)
mtext("Water Application Rate (mm/day)",1,line=1)
mtext(expression("Applied Water Volume (gal/min)"),
      1,line=4,col="blue")
mtext(expression("Truckloads/day (1 truck = 4000 gal)"),
      3,line=1,col="blue")
mtext(expression("Equilibration Time (year)"),
      2,line=1)
dev.off()




## plot time series of solute entering the groundwater
jpeg(filename=paste(figure.dir,"solute_ts.jpg",sep=""),
     width = 6.5,height = 4.5,
     units = "in",res = 600, quality = 100)
par(mgp=c(2.,0.6,0),
    mar=c(3.6,3.6,1,1),
    oma=c(0,0,0,0))
icase = "base"
unique.index = match(unique(surface.data[[icase]][,1]),
                     surface.data[[icase]][,1])
plot(surface.data[[icase]][unique.index,1],
     surface.data[[icase]][unique.index,solute.index]/crib.area,
     ylim=c(0,5000000),
     xlim=c(1950,2300),
     type="l",
     lwd=3,
     lty=2,
     xlab="Time(year)",
     ylab=expression("I-129 Flux Rate (pCi/yr/" ~ m^2 ~")")
     )
for (icase in cases)
{
    unique.index = match(unique(surface.data[[icase]][,1]),
                         surface.data[[icase]][,1])
    
    lines(surface.data[[icase]][unique.index,1],
          surface.data[[icase]][unique.index,6]/crib.area,
          col=colors[icase],lwd=2)

}
icase = "base"
unique.index = match(unique(surface.data[[icase]][,1]),
                     surface.data[[icase]][,1])
lines(surface.data[[icase]][unique.index,1],
      surface.data[[icase]][unique.index,6]/crib.area,
      col="black",lwd=3,lty=2)

## arrows(2018,30000,2018,0,length=0.15,angle=15,code=2,
##        col="black")

legend("topright",c("base",cases[lengend.index]),
       lty=c(2,rep(1,length(lengend.index))),
       col=c("black",colors[lengend.index]),bty="n",
       lwd=c(3,rep(2,length(lengend.index))))       

dev.off()


## plot time series of water entering the groundwater
jpeg(filename=paste(figure.dir,"aqueous_ts.jpg",sep=""),
     width = 6.5,height = 4.5,
     units = "in",res = 600, quality = 100)
par(mgp=c(2.,0.6,0),
    mar=c(3.6,3.6,1,1),
    oma=c(0,0,0,0))
icase = "base"
unique.index = match(unique(surface.data[[icase]][,1]),
                     surface.data[[icase]][,1])
plot(surface.data[[icase]][unique.index,1],
     surface.data[[icase]][unique.index,wt.flux.index]/crib.area,
     ylim=c(0,6000),
     xlim=c(1950,2300),
     type="l",
     lwd=3,
     lty=2,
     xlab="Time(year)",
     ylab=expression("Aqueous Flux Rate (mm/yr)")
     )
for (icase in cases)
{
    unique.index = match(unique(surface.data[[icase]][,1]),
                         surface.data[[icase]][,1])
    
    lines(surface.data[[icase]][unique.index,1],
          surface.data[[icase]][unique.index,wt.flux.index]/crib.area,
          col=colors[icase],lwd=2)

}
icase = "base"
unique.index = match(unique(surface.data[[icase]][,1]),
                     surface.data[[icase]][,1])
lines(surface.data[[icase]][unique.index,1],
      surface.data[[icase]][unique.index,wt.flux.index]/crib.area,
      col="black",lwd=3,lty=2)

## arrows(2018,100,2018,0,length=0.15,angle=15,code=2,
##        col="black")

legend("topright",c("base",cases[lengend.index]),
       lty=c(2,rep(1,length(lengend.index))),
       col=c("black",colors[lengend.index]),bty="n",
       lwd=c(3,rep(2,length(lengend.index))))       

dev.off()


## plot time series of solute entering the groundwater
# the value of the solute is scaled  by base case
jpeg(filename=paste(figure.dir,"solute_ts_scale.jpg",sep=""),
     width = 6.5,height = 4.5,
     units = "in",res = 600, quality = 100)
par(mgp=c(2.,0.6,0),
    mar=c(3.6,3.6,1,1),
    oma=c(0,0,0,0))
icase = "base"
unique.index = match(unique(surface.data[[icase]][,1]),
                     surface.data[[icase]][,1])
plot(surface.data[[icase]][unique.index,1],
     (surface.data[[icase]][unique.index,solute.index]/
     surface.data[["base"]][unique.index,solute.index]),
     ylim=c(0,150),
     xlim=c(1950,2300),
     type="l",
     lwd=3,
     lty=2,
     xlab="Time(year)",
##     ylab=expression("I-129 Flux Rate (pCi/yr/" ~ m^2 ~")")
     ylab=expression("I-129 Flux Rate Normalized to Baseline (-)")
     )
for (icase in cases)
{
    unique.index = match(unique(surface.data[[icase]][,1]),
                         surface.data[[icase]][,1])
    base.interp = approx(surface.data[["base"]][,1],
                         surface.data[["base"]][,solute.index],
                         surface.data[[icase]][unique.index,1]
                         )
    base.interp = as.numeric(base.interp[[2]])
    lines(surface.data[[icase]][unique.index,1],
        surface.data[[icase]][unique.index,solute.index]/base.interp,
          col=colors[icase],lwd=2)

}
icase = "base"
unique.index = match(unique(surface.data[[icase]][,1]),
                     surface.data[[icase]][,1])
lines(surface.data[[icase]][unique.index,1],
     (surface.data[[icase]][unique.index,solute.index]/
     surface.data[["base"]][unique.index,solute.index]),
      col="black",lwd=3,lty=2)

## arrows(2018,50,2018,0,length=0.15,angle=15,code=2,
##        col="black")

legend("topright",c("base",cases[lengend.index]),
       lty=c(2,rep(1,length(lengend.index))),
       col=c("black",colors[lengend.index]),bty="n",
       lwd=c(3,rep(2,length(lengend.index))))       

dev.off()




## plot time series of water entering the groundwater
# the value of the solute is scaled  by base case
jpeg(filename=paste(figure.dir,"aqueous_ts_scale.jpg",sep=""),
     width = 6.5,height = 4.5,
     units = "in",res = 600, quality = 100)
par(mgp=c(2.,0.6,0),
    mar=c(3.6,3.6,1,1),
    oma=c(0,0,0,0))
icase = "base"
unique.index = match(unique(surface.data[[icase]][,1]),
                     surface.data[[icase]][,1])
plot(surface.data[[icase]][unique.index,1],
     rep(1,length(unique.index)),
     ylim=c(0,150),
     xlim=c(1950,2300),
     type="l",
     lwd=3,
     lty=2,
     xlab="Time(year)",
     ##     ylab=expression("Aqueous Flux Rate (mm/yr)")
     ylab=expression("Aqueous Flux Rate Normalized to Baseline (-)")     
     )
for (icase in cases)
{
    unique.index = match(unique(surface.data[[icase]][,1]),
                         surface.data[[icase]][,1])
    base.interp = approx(surface.data[["base"]][,1],
                         surface.data[["base"]][,wt.flux.index],
                         surface.data[[icase]][unique.index,1]
                         )
    base.interp = as.numeric(base.interp[[2]])    
    lines(surface.data[[icase]][unique.index,1],
          surface.data[[icase]][unique.index,wt.flux.index]/base.interp,
          col=colors[icase],lwd=2)

}
icase = "base"
unique.index = match(unique(surface.data[[icase]][,1]),
                     surface.data[[icase]][,1])
lines(surface.data[[icase]][unique.index,1],rep(1,length(unique.index)),
      col="black",lwd=3,lty=2)

## arrows(2018,100,2018,0,length=0.15,angle=15,code=2,
##        col="black")

legend("topright",c("base",cases[lengend.index]),
       lty=c(2,rep(1,length(lengend.index))),
       col=c("black",colors[lengend.index]),bty="n",
       lwd=c(3,rep(2,length(lengend.index))))       

dev.off()

save(list=ls(),file=paste(results.dir,"results.r",sep=""))
###1 -- "Aqueous Volumetric Flux, l/yr, m^3"
###2 -- "Aqueous Volumetric Flux, l/yr, m^3"
###3 -- "Solute Flux (i-129), 1/yr, sol"
###4 -- "Aqueous Volumetric Flux, l/yr, m^3"
###5 -- "Aqueous Volumetric Flux, l/yr, m^3"
###6 -- "Solute Flux (i-129), 1/yr, sol"
###7 -- "Aqueous Volumetric Flux, l/yr, m^3"
###8 -- "Aqueous Volumetric Flux, l/yr, m^3"
