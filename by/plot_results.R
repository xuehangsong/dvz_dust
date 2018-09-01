rm(list=ls())

## file location
scripts.dir="/people/song884/github/dvz_dust/by/"
source(paste(scripts.dir,"parameter.R",sep=""))
cases = cases[1:50]
rate = rate[1:50]
ncase=length(cases)
nrate=length(rate)

fig.dir = fig.dir="/people/song884/dust/fy18/by_figures/"

## list cases
groups = c("by_2a",
              "by_1a",
              "by_3a",
              "by_6a",
              "by_7a",
              "by_8a",
              "by_9a",
              "by_10a"                                                        
           )

ngroup = length(groups)
group.dir = paste("/pic/projects/dvz/xhs_simus/dust/fy18/",groups,sep="")

## legend: group.name
legend.txt = c(expression("BY_L"),
               expression("BY_M"),
               expression("BY_H"),
               expression("BY_R1"),
               expression("BY_R2"),
               expression("BY_R3"),
               expression("BY_R4"),
               expression("BY_R5"))

## color for groups
combined.color = c("red","green","blue","grey","grey","grey","grey","grey","grey")
combined.lty = c(1,1,1,1,1,1,1,1,1)

colors = rainbow(ncase,end=0.65)
names(colors) = cases
rate.at = seq(0,100,20)
truckload.label = seq(0,250,10)
truckload.at = truckload.label*15.14165*1000/crib.area
year.at = seq(2010,2100,2)
solute.at = seq(0,3000000,500000)
legend.index = c(1,10,20,30,40,50)


## load surface data
all.surface = list()
for (igroup in 1:ngroup)
{
    print(igroup)
    load(paste(group.dir[igroup],"/surface_data.r",sep=""))
    all.surface[[groups[igroup]]] = surface.data
}

## load conc data
all.conc = list()
for (igroup in 1:ngroup)
{
    print(igroup)
    load(paste(group.dir[igroup],"/solute_conc.r",sep=""))
    all.conc[[groups[igroup]]] = solute.conc
}

## find the peak year and peak flux of  i129 entering the saturated zone
peak.solute = list()
peak.year = list()
for (igroup in groups)
{
    peak.solute[igroup] = c()
    peak.year[igroup] = c()    
    
    for (icase in c("base",cases))
    {
        case.time.data =all.surface[[igroup]][[icase]][,"time"]
        case.solute.data = all.surface[[igroup]][[icase]][,"crib.solute"]
        
        peak.solute[[igroup]] = c(peak.solute[[igroup]],
                                  max(case.solute.data)/crib.area)
        peak.year[[igroup]] = c(peak.year[[igroup]],
                                case.time.data[which.max(case.solute.data)])
    }
}




                                        # caculate equilibration time
equi.wt.year = list()
equi.solute.year = list()
interp.t = seq(2018,3000,0.01)
for (igroup in groups)
{
    print(igroup)
    ## find when system return to natural status (equilibration)
    equi.solute.value = crib.area*1
    equi.wt.value =  tail(all.surface[[igroup]][["base"]][,"crib.water"],1)
    equi.solute.year[[igroup]] = c()
    equi.wt.year[[igroup]] = c()
    for (icase in c("base",cases))
    {
                                        #        print(icase)
        interp.wt = approx(all.surface[[igroup]][[icase]][,"time"],
                           all.surface[[igroup]][[icase]][,"crib.water"],                           
                           interp.t)[[2]]
        interp.solute = approx(all.surface[[igroup]][[icase]][,"time"],
                               all.surface[[igroup]][[icase]][,"crib.solute"],                           
                               interp.t)[[2]]
        
        wt.index = which(abs(interp.wt-equi.wt.value)/equi.wt.value>=1)
        wt.index = tail(wt.index,1)+1
        equi.wt.year[[igroup]] = c(equi.wt.year[[igroup]],interp.t[wt.index])

        solute.index = which(abs(interp.solute)>equi.solute.value)
        solute.index = tail(solute.index,1)+1
        equi.solute.year[[igroup]] = c(equi.solute.year[[igroup]],interp.t[solute.index])
    }
}

jpeg(filename=paste(fig.dir,"combined_peak_flux.jpg",sep=""),
     width = 8,height = 5,
     units = "in",res = 600, quality = 100)
par(mgp=c(2.,0.,0),
    mar=c(5.0,2.4,2.4,0.5),    
    oma=c(0,0,0,0))
plot(c(0,rate),peak.solute[[groups[1]]],
     type="l",
     lwd=1,
     lty=1,
     pch=1,
     col="white",
     xlab=NA,
     ylab=NA,
     ylim=c(0,2e3),     
     axes=FALSE,
     )
box()
for (igroup in 1:(ngroup/1))
{
    print(igroup)
    #    points(c(0,rate),peak.solute.list[[igroup]],col="grey",cex=0.4)
#    points(0,peak.solute[[groups[igroup]]][1],pch=1)

    rate.plot = c(0,rate)
    solute.plot = peak.solute[[groups[igroup]]]

    rate.plot = 0
    solute.plot = peak.solute[[groups[igroup]]][1]
    for (irate in 1:length(rate))
    {
        if (max(solute.plot)< peak.solute[[groups[igroup]]][irate+1])
        {
            rate.plot = c(rate.plot,rate[irate])
            solute.plot = c(solute.plot, peak.solute[[groups[igroup]]][irate+1])
        }
    }
    lines(rate.plot,solute.plot,
          col=combined.color[igroup],
          lwd=2,
          lty=combined.lty[igroup]
          )
}
axis(1,at=rate.at,labels=rate.at,tck=0.02)
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
mtext(expression("NO"[3]~"- Flux Rate (kg/L)"),
      2,line=1)
legend("topleft",legend.txt[1:ngroup],
       lty=combined.lty,
       col=combined.color,
       lwd=2,bty="n")
dev.off()


jpeg(filename=paste(fig.dir,"combined_peak_year.jpg",sep=""),
     width = 8,height = 5,
     units = "in",res = 600, quality = 100)
par(mgp=c(2.,0.,0),
    mar=c(5.0,2.4,2.4,0.5),    
    oma=c(0,0,0,0))
plot(c(0,rate),peak.year[[groups[1]]],
     type="l",
     lwd=1,
     lty=1,
     pch=1,
     col="white",
     xlab=NA,
     ylab=NA,
     ylim=c(2018,2026),
     axes=FALSE,
     )
box()
for (igroup in 1:ngroup)
{
    print(igroup)
                                        #    points(0,peak.year[[groups[igroup]]][1],pch=1)

    rate.plot = c(rate)
    year.plot = peak.year[[groups[igroup]]][-1]

    ## rate.plot = rate[nrate]
    ## year.plot = peak.year[[groups[igroup]]][nrate]
    ## for (irate in length(rate-1):1)
    ## {
    ##     if (max(year.plot)< peak.year[[groups[igroup]]][irate])
    ##     {
    ##         rate.plot = c(rate[irate],rate.plot)
    ##         year.plot = c(peak.year[[groups[igroup]]][irate+1],year.plot)
    ##     }
    ## }
    lines(rate.plot,year.plot,
          col=combined.color[igroup],
          lwd=2,
          lty=combined.lty[igroup]
          )
}
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
legend("topright",legend.txt[1:ngroup],
       lty=combined.lty,
       col=combined.color,
       lwd=2,bty="n")
dev.off()



jpeg(filename=paste(fig.dir,"combined_equal_wt_year.jpg",sep=""),
     width = 8,height = 5,
     units = "in",res = 600, quality = 100)
par(mgp=c(2.,0.,0),
    mar=c(5.0,2.4,2.4,0.5),    
    oma=c(0,0,0,0))
plot(c(0,rate),equi.wt.year[[groups[1]]],
     type="l",
     lwd=1,
     lty=1,
     pch=1,
     col="white",
     xlab=NA,
     ylab=NA,
     ylim=c(2120,2130),     
     axes=FALSE,
     )
box()
for (igroup in 1:ngroup)
{
    print(igroup)

    rate.plot = c(rate)
    equi.plot = equi.wt.year[[groups[igroup]]][-1]
    ## rate.plot = rate[1]
    ## equi.plot = equi.wt.year[[groups[igroup]]][1]
    ## for (irate in 2:length(rate))
    ## {
    ##     if (max(equi.plot)<= equi.wt.year[[groups[igroup]]][irate] &
    ##         tail(peak.solute[[groups[igroup]]],1)>= equi.wt.year[[groups[igroup]]][irate])
    ##     {
    ##         rate.plot = c(rate.plot,rate[irate])
    ##         equi.plot = c(equi.plot, equi.wt.year[[groups[igroup]]][irate])
    ##     }
    ## }
    lines(rate.plot,equi.plot,
          col=combined.color[igroup],
          lwd=2,
          lty=combined.lty[igroup]
          )
    
}
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
legend("topleft",legend.txt[1:ngroup],
       lty=combined.lty,
       col=combined.color,
       lwd=2,bty="n")
dev.off()




jpeg(filename=paste(fig.dir,"combined_equal_solute_year.jpg",sep=""),
     width = 8,height = 5,
     units = "in",res = 600, quality = 100)
par(mgp=c(2.,0.,0),
    mar=c(5.0,2.4,2.4,0.5),    
    oma=c(0,0,0,0))
plot(c(0,rate),equi.solute.year[[groups[1]]],
     type="l",
     lwd=1,
     lty=1,
     pch=1,
     col="white",
     xlab=NA,
     ylab=NA,
     ylim=c(2000,2100),     
     axes=FALSE,
     )
box()
for (igroup in 1:(ngroup))
{
    print(igroup)

    rate.plot = c(rate)
    equi.plot = equi.solute.year[[groups[igroup]]][-1]
    ## rate.plot = 0
    ## equi.plot = equi.solute.year[[groups[igroup]]][1]
    ## for (irate in 2:length(rate))
    ## {
    ##     if (max(equi.plot)<= equi.solute.year[[groups[igroup]]][irate+1] &
    ##         tail(peak.solute[[groups[igroup]]],1)>= equi.solute.year[[groups[igroup]]][irate])
    ##     {
    ##         rate.plot = c(rate.plot,rate[irate])
    ##         equi.plot = c(equi.plot, equi.solute.year[[groups[igroup]]][irate])
    ##     }
    ## }
    lines(rate.plot,equi.plot,
          col=combined.color[igroup],
          lwd=2,
          lty=combined.lty[igroup]
          )
    
}
axis(1,at=rate.at,labels=rate.at,tck=0.02)
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
legend("topright",legend.txt[1:ngroup],
       lty=combined.lty,
       col=combined.color,
       lwd=2,bty="n")
dev.off()


for (igroup in groups)
{
    jpeg(filename=paste(fig.dir,igroup,"_solute_ts.jpg",sep=""),
         width = 8,height = 3,
         units = "in",res = 600, quality = 100)
    par(mgp=c(2.,0.6,0),
        mar=c(3.6,3.6,1,1),
        oma=c(0,0,0,0))
    icase = "base"
    time.plot = c(all.surface[[igroup]][["2018"]][,"time"],
                  all.surface[[igroup]][[icase]][,"time"])
    solute.plot = c(all.surface[[igroup]][["2018"]][,"crib.solute"],
                    all.surface[[igroup]][[icase]][,"crib.solute"])
    unique.index = match(unique(time.plot),time.plot)
    plot(time.plot[unique.index],
         solute.plot[unique.index]/crib.area,
         ylim=c(0,3000),
         xlim=c(1950,2100),
         type="l",
         lwd=3,
         lty=2,
         xlab="Time(year)",
         ylab=expression("NO"[3]~"- Flux Rate (kg/yr/"~ m^2 ~")")
         )
    for (icase in cases)
    {
        time.plot = c(all.surface[[igroup]][["2018"]][,"time"],
                      all.surface[[igroup]][[icase]][,"time"])
        solute.plot = c(all.surface[[igroup]][["2018"]][,"crib.solute"],
                        all.surface[[igroup]][[icase]][,"crib.solute"])
        unique.index = match(unique(time.plot),time.plot)
        lines(time.plot[unique.index],
              solute.plot[unique.index]/crib.area,
              col=colors[icase],lwd=2)
    }
    icase = "base"
    time.plot = c(all.surface[[igroup]][["2018"]][,"time"],
                  all.surface[[igroup]][[icase]][,"time"])
    solute.plot = c(all.surface[[igroup]][["2018"]][,"crib.solute"],
                    all.surface[[igroup]][[icase]][,"crib.solute"])
    unique.index = match(unique(time.plot),time.plot)
    lines(time.plot[unique.index],
          solute.plot[unique.index]/crib.area,
          col="black",lwd=3,lty=2)
    legend("topright",c("natural recharge",cases[legend.index]),
           lty=c(2,rep(1,length(legend.index))),
           col=c("black",colors[legend.index]),bty="n",
           lwd=c(3,rep(2,length(legend.index))))       
    dev.off()
}


for (igroup in groups)
{
    jpeg(filename=paste(fig.dir,igroup,"_wt_ts.jpg",sep=""),
         width = 8,height = 3,
         units = "in",res = 600, quality = 100)
    par(mgp=c(2.,0.6,0),
        mar=c(3.6,3.6,1,1),
        oma=c(0,0,0,0))
    icase = "base"
    time.plot = c(all.surface[[igroup]][["2018"]][,"time"],
                  all.surface[[igroup]][[icase]][,"time"])
    wt.plot = c(all.surface[[igroup]][["2018"]][,"crib.water"],
                    all.surface[[igroup]][[icase]][,"crib.water"])
    unique.index = match(unique(time.plot),time.plot)
    plot(time.plot[unique.index],
         wt.plot[unique.index]/crib.area,
         ylim=c(0,50000),
         xlim=c(1950,2100),
         type="l",
         lwd=3,
         lty=2,
         xlab="Time(year)",
         ylab=expression("Aqueous Flux Rate (mm/yr/"~m^2~")"),
         )
    for (icase in cases)
    {
        time.plot = c(all.surface[[igroup]][["2018"]][,"time"],
                      all.surface[[igroup]][[icase]][,"time"])
        wt.plot = c(all.surface[[igroup]][["2018"]][,"crib.water"],
                        all.surface[[igroup]][[icase]][,"crib.water"])
        unique.index = match(unique(time.plot),time.plot)
        lines(time.plot[unique.index],
              wt.plot[unique.index]/crib.area,
              col=colors[icase],lwd=2)
    }
    icase = "base"
    time.plot = c(all.surface[[igroup]][["2018"]][,"time"],
                  all.surface[[igroup]][[icase]][,"time"])
    wt.plot = c(all.surface[[igroup]][["2018"]][,"crib.water"],
                    all.surface[[igroup]][[icase]][,"crib.water"])
    unique.index = match(unique(time.plot),time.plot)
    lines(time.plot[unique.index],
          wt.plot[unique.index]/crib.area,
          col="black",lwd=3,lty=2)
    legend("topright",c("natural recharge",cases[legend.index]),
           lty=c(2,rep(1,length(legend.index))),
           col=c("black",colors[legend.index]),bty="n",
           lwd=c(3,rep(2,length(legend.index))))       
    dev.off()
}
