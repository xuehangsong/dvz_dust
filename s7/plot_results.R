rm(list=ls())

## file location
scripts.dir="/people/song884/github/dvz_dust/s7/"
source(paste(scripts.dir,"parameter.R",sep=""))
cases = cases[1:50]
cases.l = cases.l[1:4]
rate = rate[1:50]
rate.l = rate.l[1:4]
ncase=length(cases)
nrate=length(rate)
ncase.l = length(cases.l)

cases.l.legend = paste(rate.l,"mm/day")
cases.legend = paste(rate,"mm/day")

fig.dir = fig.dir="/people/song884/dust/fy18/s7_figures/"

## list cases
groups = c("s7_2a",
           "s7_1a",
           "s7_3a",
           "s7_6a",
           "s7_7a",
           "s7_8a",
           "s7_9a",
           "s7_10a",
           "s7_2b",
           "s7_1b",
           "s7_3b",
           "s7_6b",
           "s7_7b",
           "s7_8b",
           "s7_9b",                                          
           "s7_10b")
ngroup = length(groups)
group.dir = paste("/pic/projects/dvz/xhs_simus/dust/fy18/",groups,sep="")

                                        # legend: group.name
legend.txt = c(expression("S7_L, "~k[d]~"=0.0 cm"^3~"/g"),
               expression("S7_M, "~k[d]~"=0.0 cm"^3~"/g"),
               expression("S7_H, "~k[d]~"=0.0 cm"^3~"/g"),
               expression("S7_R1, "~k[d]~"=0.0 cm"^3~"/g"),
               expression("S7_R2, "~k[d]~"=0.0 cm"^3~"/g"),
               expression("S7_R3, "~k[d]~"=0.0 cm"^3~"/g"),
               expression("S7_R4, "~k[d]~"=0.0 cm"^3~"/g"),
               expression("S7_R5, "~k[d]~"=0.0 cm"^3~"/g"),               
               expression("S7_L, "~k[d]~"=0.1 cm"^3~"/g"),
               expression("S7_M, "~k[d]~"=0.1 cm"^3~"/g"),
               expression("S7_H, "~k[d]~"=0.1 cm"^3~"/g"),
               expression("S7_R1, "~k[d]~"=0.1 cm"^3~"/g"),
               expression("S7_R2, "~k[d]~"=0.1 cm"^3~"/g"),
               expression("S7_R3, "~k[d]~"=0.1 cm"^3~"/g"),
               expression("S7_R4, "~k[d]~"=0.1 cm"^3~"/g"),
               expression("S7_R5, "~k[d]~"=0.1 cm"^3~"/g")
               )

## color for groups
combined.color = c("red","green","blue","grey","grey","grey","grey","grey",
                   "red","green","blue","grey","grey","grey","grey","grey")
## line type
combined.lty = c(1,1,1,1,1,1,1,1,
                 2,2,2,2,2,2,2,2)

colors = rev(topo.colors(ncase))
colors = rainbow(ncase,end=0.65)
names(colors) = cases

colors.l = rev(topo.colors(ncase.l))
colors.l = rainbow(ncase.l,end=0.65)
names(colors.l) = cases.l


##rate.at = c(0,50,100,150,200,250,300,350,400)
##truckload.at = c(0,1,2,3,4,5,6,7,8,9)*15.14165*1000/crib.area
##truckload.label = c(0,1,2,3,4,5,6,7,8,9)
rate.at = seq(0,100,20)
year.at = seq(2010,2100,2)
mini.ticks = seq(0000,2100,5)
main.ticks = seq(1950,2100,25)
truckload.at = seq(0,10,0.5)*15.14165*1000/crib.area
truckload.label = seq(0,10,0.5)
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


## find the peak year and peak flux of  i129 entering the saturated zone
peak.mean.conc = list()
peak.max.conc = list()
for (igroup in groups)
{
    peak.mean.conc[[igroup]] = c()
    peak.max.conc[[igroup]] = c()    
    
    for (icase in c("base",cases.l))
    {
        peak.mean.conc[[igroup]] = c(peak.mean.conc[[igroup]],
                                   max(all.conc[[igroup]][[icase]][,"crib.mean"]))
        peak.max.conc[[igroup]] = c(peak.max.conc[[igroup]],
            max(all.conc[[igroup]][[icase]][,"domain.max"]))        
    }
}




## caculate equilibration time
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
        ##        print(icase)
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


for (igroup in groups)
{
    jpeg(filename=paste(fig.dir,igroup,"_conc_crib_mean.jpg",sep=""),
         width = 8,height = 3,
         units = "in",res = 600, quality = 100)
    par(mgp=c(2.,0.6,0),
        mar=c(3.6,3.6,1,1),
        oma=c(0,0,0,0))
    icase = "base"
    plot(c(all.conc[[igroup]][["2018"]][,"time"],all.conc[[igroup]][["base"]][,"time"]),
         c(all.conc[[igroup]][["2018"]][,"crib.mean"],all.conc[[igroup]][["base"]][,"crib.mean"]),
         ylim=c(0,20),
         xlim=c(1950,2100),
         type="l",
         lwd=3,
         lty=2,
         xlab="Time(year)",
         ylab = "I-129 (pCi/L)",         
         )
    axis(1,mini.ticks,labels=rep("",length(mini.ticks)),tck=-0.025)
    axis(1,main.ticks)
    for (icase in cases.l)
    {
        lines(c(all.conc[[igroup]][["2018"]][,"time"],all.conc[[igroup]][[icase]][,"time"]),
              c(all.conc[[igroup]][["2018"]][,"crib.mean"],all.conc[[igroup]][[icase]][,"crib.mean"]),
              col=colors.l[icase],lwd=2)
    }
    icase = "base"
    lines(c(all.conc[[igroup]][["2018"]][,"time"],all.conc[[igroup]][["base"]][,"time"]),
          c(all.conc[[igroup]][["2018"]][,"crib.mean"],all.conc[[igroup]][["base"]][,"crib.mean"]),
          col="black",lwd=3,lty=2)
    legend("topright",c("natural recharge",cases.l.legend),
           lty=c(2,rep(1,ncase.l)),
           col=c("black",colors.l),bty="n",
           lwd=c(3,rep(2,ncase.l)))       
    dev.off()
}


for (igroup in groups)
{
    jpeg(filename=paste(fig.dir,igroup,"_conc_domain_mean.jpg",sep=""),
         width = 8,height = 3,
         units = "in",res = 600, quality = 100)
    par(mgp=c(2.,0.6,0),
        mar=c(3.6,3.6,1,1),
        oma=c(0,0,0,0))
    icase = "base"
    plot(c(all.conc[[igroup]][["2018"]][,"time"],all.conc[[igroup]][["base"]][,"time"]),
         c(all.conc[[igroup]][["2018"]][,"domain.mean"],all.conc[[igroup]][["base"]][,"domain.mean"]),
         ylim=c(0,0.015),
         xlim=c(1950,2100),
         type="l",
         lwd=3,
         lty=2,
         xlab="Time(year)",
         ylab = "I-129 (pCi/L)",         
         )
    axis(1,mini.ticks,labels=rep("",length(mini.ticks)),tck=-0.025)
    axis(1,main.ticks)
    for (icase in cases.l)
    {
        lines(c(all.conc[[igroup]][["2018"]][,"time"],all.conc[[igroup]][[icase]][,"time"]),
              c(all.conc[[igroup]][["2018"]][,"domain.mean"],all.conc[[igroup]][[icase]][,"domain.mean"]),
              col=colors.l[icase],lwd=2)
    }
    icase = "base"
    lines(c(all.conc[[igroup]][["2018"]][,"time"],all.conc[[igroup]][["base"]][,"time"]),
          c(all.conc[[igroup]][["2018"]][,"domain.mean"],all.conc[[igroup]][["base"]][,"domain.mean"]),
          col="black",lwd=3,lty=2)
    legend("topright",c("natural recharge",cases.l.legend),
           lty=c(2,rep(1,ncase.l)),
           col=c("black",colors.l),bty="n",
           lwd=c(3,rep(2,ncase.l)))       
    dev.off()
}


for (igroup in groups)
{
    jpeg(filename=paste(fig.dir,igroup,"_conc_domain_max.jpg",sep=""),
         width = 8,height = 3,
         units = "in",res = 600, quality = 100)
    par(mgp=c(2.,0.6,0),
        mar=c(3.6,3.6,1,1),
        oma=c(0,0,0,0))
    icase = "base"
    plot(c(all.conc[[igroup]][["2018"]][,"time"],all.conc[[igroup]][["base"]][,"time"]),
         c(all.conc[[igroup]][["2018"]][,"domain.max"],all.conc[[igroup]][["base"]][,"domain.max"]),
         ylim=c(0,1000),
         xlim=c(1950,2100),
         type="l",
         lwd=3,
         lty=2,
         xlab="Time(year)",
         ylab = "I-129 (pCi/L)",         
         )
    axis(1,mini.ticks,labels=rep("",length(mini.ticks)),tck=-0.025)
    axis(1,main.ticks)
    for (icase in cases.l)
    {
        lines(c(all.conc[[igroup]][["2018"]][,"time"],all.conc[[igroup]][[icase]][,"time"]),
              c(all.conc[[igroup]][['2018']][,"domain.max"],all.conc[[igroup]][[icase]][,"domain.max"]),
              col=colors.l[icase],lwd=2)
    }
    icase = "base"
    lines(c(all.conc[[igroup]][["2018"]][,"time"],all.conc[[igroup]][["base"]][,"time"]),
          c(all.conc[[igroup]][["2018"]][,"domain.max"],all.conc[[igroup]][["base"]][,"domain.max"]),          
          col="black",lwd=3,lty=2)
    legend("topright",c("natural recharge",cases.l.legend),
           lty=c(2,rep(1,ncase.l)),
           col=c("black",colors.l),bty="n",
           lwd=c(3,rep(2,ncase.l)))       
    dev.off()
}


for (igroup in groups)
{
    jpeg(filename=paste(fig.dir,igroup,"_conc_crib_max.jpg",sep=""),
         width = 8,height = 3,
         units = "in",res = 600, quality = 100)
    par(mgp=c(2.,0.6,0),
        mar=c(3.6,3.6,1,1),
        oma=c(0,0,0,0))
    icase = "base"
    plot(c(all.conc[[igroup]][["2018"]][,"time"],all.conc[[igroup]][["base"]][,"time"]),
         c(all.conc[[igroup]][["2018"]][,"crib.max"],all.conc[[igroup]][["base"]][,"crib.max"]),
         ylim=c(0,1000),
         xlim=c(1950,2100),
         type="l",
         lwd=3,
         lty=2,
         xlab="Time(year)",
         ylab = "I-129 (pCi/L)",         
         )
    axis(1,mini.ticks,labels=rep("",length(mini.ticks)),tck=-0.025)
    axis(1,main.ticks)
    for (icase in cases.l)
    {
        lines(c(all.conc[[igroup]][["2018"]][,"time"],all.conc[[igroup]][[icase]][,"time"]),
              c(all.conc[[igroup]][["2018"]][,"crib.max"],all.conc[[igroup]][[icase]][,"crib.max"]),
              col=colors.l[icase],lwd=2)
    }
    icase = "base"
    lines(c(all.conc[[igroup]][["2018"]][,"time"],all.conc[[igroup]][["base"]][,"time"]),
          c(all.conc[[igroup]][["2018"]][,"crib.max"],all.conc[[igroup]][["base"]][,"crib.max"]),          
          col="black",lwd=3,lty=2)
    legend("topright",c("natural recharge",cases.l.legend),
           lty=c(2,rep(1,ncase.l)),
           col=c("black",colors.l),bty="n",
           lwd=c(3,rep(2,ncase.l)))       
    dev.off()
}


jpeg(filename=paste(fig.dir,"combined_peak_mean_conc.jpg",sep=""),
     width = 8,height = 5,
     units = "in",res = 600, quality = 100)
par(mgp=c(2.,0.,0),
    mar=c(5.0,2.4,2.4,0.5),    
    oma=c(0,0,0,0))
plot(c(0,rate.l),peak.mean.conc[[groups[1]]],
     type="l",
     lwd=1,
     lty=1,
     pch=1,
     col="white",
     xlab=NA,
     ylab=NA,
     ylim=c(0,20),
     axes=FALSE,
     )
box()
for (igroup in 1:(ngroup/1))
{
    print(igroup)
    #    points(0,peak.mean.conc[[groups[igroup]]][1],pch=1)

    rate.plot = c(0,rate.l)
    solute.plot = peak.mean.conc[[groups[igroup]]]
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
mtext(expression("I-129 (pCi/L)"),
      2,line=1)
legend(45,9,legend.txt[1:(ngroup/2)],
       lty=combined.lty,
       col=combined.color,cex=0.8,
       lwd=2,bty="n")
legend(75,9,legend.txt[(ngroup/2+1):ngroup],       
       lty=combined.lty[(ngroup/2+1):ngroup],cex=0.8,
       col=combined.color[(ngroup/2+1):ngroup],       
       lwd=2,bty="n")
dev.off()


jpeg(filename=paste(fig.dir,"combined_peak_max_conc.jpg",sep=""),
     width = 8,height = 5,
     units = "in",res = 600, quality = 100)
par(mgp=c(2.,0.,0),
    mar=c(5.0,2.4,2.4,0.5),    
    oma=c(0,0,0,0))
plot(c(0,rate.l),peak.max.conc[[groups[1]]],
     type="l",
     lwd=1,
     lty=1,
     pch=1,
     col="white",
     xlab=NA,
     ylab=NA,
     ylim=c(0,1000),
     axes=FALSE,
     )
box()
for (igroup in 1:(ngroup/1))
{
    print(igroup)
    #    points(0,peak.max.conc[[groups[igroup]]][1],pch=1)

    rate.plot = c(0,rate.l)
    solute.plot = peak.max.conc[[groups[igroup]]]
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
mtext(expression("I-129 (pCi/L)"),
      2,line=1)
legend(45,450,legend.txt[1:(ngroup/2)],
       lty=combined.lty,
       col=combined.color,cex=0.8,
       lwd=2,bty="n")
legend(75,450,legend.txt[(ngroup/2+1):ngroup],       
       lty=combined.lty[(ngroup/2+1):ngroup],cex=0.8,
       col=combined.color[(ngroup/2+1):ngroup],       
       lwd=2,bty="n")
dev.off()


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
     ylim=c(0,5.2e6),
     axes=FALSE,
     )
box()
for (igroup in 1:(ngroup/1))
{
    print(igroup)
    #    points(c(0,rate),peak.solute.list[[igroup]],col="grey",cex=0.4)
    points(0,peak.solute[[groups[igroup]]][1],pch=1)

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
mtext(expression("I-129 Flux Rate (pCi/yr/"~m^2~")"),
      2,line=1)
legend(0,5.2e6,legend.txt[1:(ngroup/2)],
       lty=combined.lty,
       col=combined.color,cex=0.8,
       lwd=2,bty="n")
legend(30,5.2e6,legend.txt[(ngroup/2+1):ngroup],       
       lty=combined.lty[(ngroup/2+1):ngroup],cex=0.8,
       col=combined.color[(ngroup/2+1):ngroup],       
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
     ylim=c(2018,2030),
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
legend(40,2030.5,legend.txt[1:(ngroup/2)],
       lty=combined.lty,
       col=combined.color,cex=0.8,
       lwd=2,bty="n")
legend(70,2030.5,legend.txt[(ngroup/2+1):ngroup], cex=0.8,
       lty=combined.lty[(ngroup/2+1):ngroup],  
       col=combined.color[(ngroup/2+1):ngroup],  
       lwd=2,bty="n")
dev.off()



jpeg(filename=paste(fig.dir,"combined_equal_wt_year.jpg",sep=""),
     width = 8,height = 5,
     units = "in",res = 600, quality = 100)
par(mgp=c(2.,0.,0),
    mar=c(5.0,2.4,2.4,0.5),    
    oma=c(0,0,0,0))
plot(c(rate),equi.wt.year[[groups[1]]],
     type="l",
     lwd=1,
     lty=1,
     pch=1,
     col="white",
     xlab=NA,
     ylab=NA,
     ylim=c(2035,2050),     
     axes=FALSE,
     )
box()
for (igroup in 1:(ngroup/2))
{
    print(igroup)

    rate.plot = rate
    equi.plot = equi.wt.year[[groups[igroup]]]
    rate.plot = rate[1]
    equi.plot = equi.wt.year[[groups[igroup]]][1]
    for (irate in 2:length(rate))
    {
        if (max(equi.plot)<= equi.wt.year[[groups[igroup]]][irate] &
            tail(peak.solute[[groups[igroup]]],1)>= equi.wt.year[[groups[igroup]]][irate])
        {
            rate.plot = c(rate.plot,rate[irate])
            equi.plot = c(equi.plot, equi.wt.year[[groups[igroup]]][irate])
        }
    }
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
legend(0,2050,legend.txt[1:(ngroup/2)],
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
     ylim=c(2200,3200),     
     axes=FALSE,
     )
box()
for (igroup in 1:(ngroup))
{
    print(igroup)

    rate.plot = c(0,rate)
    equi.plot = equi.solute.year[[groups[igroup]]]
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
legend(0,3200,legend.txt[1:(ngroup/2)],
       lty=combined.lty,
       col=combined.color,cex=0.8,
       lwd=2,bty="n")
legend(30,3200,legend.txt[(ngroup/2+1):ngroup],       
       lty=combined.lty[(ngroup/2+1):ngroup],cex=0.8,
       col=combined.color[(ngroup/2+1):ngroup],       
       lwd=2,bty="n")
dev.off()


## plot time series of i129 entering the groundwater
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
         ylim=c(0,5000000),
         xlim=c(1950,2100),
         type="l",
         lwd=3,
         lty=2,
         xlab="Time(year)",
         ylab=expression("I-129 Flux Rate (pCi/yr/"~m^2~")")
         )
    axis(1,mini.ticks,labels=rep("",length(mini.ticks)),tck=-0.025)
    axis(1,main.ticks)
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
         ylim=c(0,6000),
         xlim=c(1950,2100),
         type="l",
         lwd=3,
         lty=2,
         xlab="Time(year)",
         ylab=expression("Aqueous Flux Rate (mm/yr/"~m^2~")")         
         )
    axis(1,mini.ticks,labels=rep("",length(mini.ticks)),tck=-0.025)
    axis(1,main.ticks)
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
