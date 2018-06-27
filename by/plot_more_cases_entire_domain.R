rm(list=ls())
cases.dir = c("by_2a",
              "by_1a",
              "by_4a",              
              "by_5a",
              "by_3a")
cases.dir = paste("/people/song884/dust/fy2018/",cases.dir,sep="")
combined.figure.dir="/people/song884/dust/fy2018/by_all/"

combined.color = c("red","orange","green","blue","black")
combined.lty = c(1,1,1,1,1)

solute.cum.index = 29
wt.cum.index = 27

## legend.txt = c(expression(Low ~ K[S] ~"/"~theta[S]~"with"~k[d]~"=0"),
##                expression(Mean ~ K[S] ~"/"~theta[S]~"with"~k[d]~"=0"),
##                expression(High ~ K[S] ~"/"~theta[S]~"with"~k[d]~"=0"),
##                expression(Hete. ~ K[S] ~"/"~theta[S]~"with"~k[d]~"=0"))               

legend.txt = c(expression(K[S] ~"4.12e-7 cm/s"),
               expression(K[S] ~"5.57e-5 cm/s"),
               expression(K[S] ~"1.36e-3 cm/s"),
               expression(K[S] ~"1.36e-2 cm/s"),
               expression(K[S] ~"1.36e-1 cm/s"))

ndir = length(cases.dir)

peak.solute.list = list()
peak.year.list = list()
equi.wt.year.list = list()
equi.solute.year.list = list()
spinup.wt = list()
spinup.solute = list()
for (idir in 1:ndir)
{
    print(idir)
    load(paste(cases.dir[idir],"/results_entire_domain.r",sep=""))
    peak.solute.list[[idir]] = peak.solute
    peak.year.list[[idir]] = peak.year
    equi.solute.year.list[[idir]] = equi.solute.year
    equi.wt.year.list[[idir]] = equi.wt.year
    spinup.wt[[idir]] =spinup.data[,c(1,wt.cum.index)]
    spinup.solute[[idir]] = spinup.data[,c(1,solute.cum.index)]
}

stop()
colors = rev(topo.colors(ncase))
colors = rainbow(ncase,end=0.65)
names(colors) = cases
rate.at = seq(0,500,100)
truckload.label = seq(0,250,50)
truckload.at = truckload.label*15.14165*1000/crib.area
year.at = seq(2010,2100,2)
solute.at = seq(0,3000000,500000)
lengend.index = c(1,seq(50,500,50))


jpeg(filename=paste(combined.figure.dir,"combined_cum_wt_entire_domain.jpg",sep=""),
     width = 6.5,height = 5,
     units = "in",res = 600, quality = 100)
par(mgp=c(2.,0.,0),
    mar=c(5.0,2.4,2.4,0.5),    
    oma=c(0,0,0,0))
plot(spinup.wt[[1]][,1],spinup.wt[[1]][,2],
     type="l",
     lwd=1,
     lty=1,
     pch=1,
     col="white",
     xlab=NA,
     ylab=NA,
     ylim=c(0,1.2e5),
     axes=FALSE,
     )
box()
for (idir in 1:ndir)
{
    print(idir)
    print(idir)
    lines(spinup.wt[[idir]][,1],spinup.wt[[idir]][,2],
          col=combined.color[idir],
          lwd=2,
          lty=combined.lty[idir]
          )
}
axis(1,tck=0.02)
axis(2,tck=0.02)
mtext("Time (year)",1,line=1)
mtext(expression("Water Cumulative Flux(m"^3~")"),
      2,line=1)
legend("topleft",legend.txt[1:ndir],
       lty=combined.lty,
       col=combined.color,
       lwd=2,bty="n")
dev.off()



jpeg(filename=paste(combined.figure.dir,"combined_cum_solute_entire_domain.jpg",sep=""),
     width = 6.5,height = 5,
     units = "in",res = 600, quality = 100)
par(mgp=c(2.,0.,0),
    mar=c(5.0,2.4,2.4,0.5),    
    oma=c(0,0,0,0))
plot(spinup.wt[[1]][,1],spinup.solute[[1]][,2],
     type="l",
     lwd=1,
     lty=1,
     pch=1,
     col="white",
     xlab=NA,
     ylab=NA,
     ylim=c(0,4e6),
     axes=FALSE,
     )
box()
for (idir in 1:ndir)
{
    print(idir)
    print(idir)
    lines(spinup.wt[[idir]][,1],spinup.solute[[idir]][,2],
          col=combined.color[idir],
          lwd=2,
          lty=combined.lty[idir]
          )
}
axis(1,tck=0.02)
axis(2,tck=0.02)
mtext("Time (year)",1,line=1)
mtext(expression("NO"[3]~"- Cumulative Flux (kg)"),
      2,line=1)
legend("topleft",legend.txt[1:ndir],
       lty=combined.lty,
       col=combined.color,
       lwd=2,bty="n")
dev.off()





jpeg(filename=paste(combined.figure.dir,"combined_peak_flux_entire_domain.jpg",sep=""),
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
     ylim=c(0,8e3),
     axes=FALSE,
     )
box()
for (idir in 1:ndir)
{
    print(idir)
    print(idir)
    ori.rate = rate
    ori.data = tail(peak.solute.list[[idir]],-1)
    plot.rate = rate[1]
    plot.data = ori.data[1]
    for (irate in 2:nrate)
    {
        if(ori.data[irate]>(max(plot.data)))
        {
            print(irate)
            plot.rate = c(plot.rate,ori.rate[irate])
            plot.data = c(plot.data,ori.data[irate])            
        }
    }
    lines(plot.rate,plot.data,
          col=combined.color[idir],
          lwd=2,
          lty=combined.lty[idir]
          )
    ## points(0,peak.solute.list[[idir]][1],pch=1)
    ## lines(c(0,rate),peak.solute.list[[idir]],
    ##       col=combined.color[idir],
    ##       lwd=2,
    ##       lty=combined.lty[idir]
    ##       )
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
mtext(expression("NO"[3]~"- Flux Rate (kg/yr/" ~ m^2 ~")"),
      2,line=1)
legend("topleft",legend.txt[1:ndir],
       lty=combined.lty,
       col=combined.color,
       lwd=2,bty="n")
dev.off()






jpeg(filename=paste(combined.figure.dir,"combined_peak_year_entire_domain.jpg",sep=""),
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
     ylim=c(2018,2026),
     axes=FALSE,
     )
box()
for (idir in 1:ndir)
{
    print(idir)
    ori.rate = rate
    ori.data = tail(peak.year.list[[idir]],-1)
    plot.rate = rate[1]
    plot.data = ori.data[1]
    for (irate in 2:nrate)
    {
        if(ori.data[irate]<min(plot.data))
        {
            print(irate)
            plot.rate = c(plot.rate,ori.rate[irate])
            plot.data = c(plot.data,ori.data[irate])            
        }
    }
    lines(plot.rate,plot.data,
          col=combined.color[idir],
          lwd=2,
          lty=combined.lty[idir]
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
legend("topright",legend.txt[1:ndir],
       lty=combined.lty,
       col=combined.color,
       lwd=2,bty="n")
dev.off()






jpeg(filename=paste(combined.figure.dir,"combined_equal_solute_year_entire_domain.jpg",sep=""),
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
     ylim=c(2500,3000)
     )
box()
for (idir in 1:ndir)
{
    print(idir)
    lines(c(rate),tail(equi.solute.year.list[[idir]],-1),
          col=combined.color[idir],
          lwd=2,
          lty=combined.lty[idir]
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
legend("topright",legend.txt[1:ndir],
       lty=combined.lty,
       col=combined.color,
       lwd=2,bty="n")
dev.off()



jpeg(filename=paste(combined.figure.dir,"combined_equal_wt_year_entire_domain.jpg",sep=""),
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
     ylim=c(2082,2087),
     axes=FALSE,
     )
box()
for (idir in 1:ndir)
{
    print(idir)
    ori.rate = rate
    ori.data = tail(equi.wt.year.list[[idir]],-1)
    plot.rate = rate[1]
    plot.data = ori.data[1]
    for (irate in 2:nrate)
    {
        if(ori.data[irate]>(max(plot.data)-0.05))
        {
            print(irate)
            plot.rate = c(plot.rate,ori.rate[irate])
            plot.data = c(plot.data,ori.data[irate])            
        }
    }
    lines(plot.rate,plot.data,
          col=combined.color[idir],
          lwd=2,
          lty=combined.lty[idir]
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
legend("topright",legend.txt[1:ndir],
       lty=combined.lty,
       col=combined.color,
       lwd=2,bty="n")
dev.off()
