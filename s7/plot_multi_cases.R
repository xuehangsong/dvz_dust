rm(list=ls())
cases.dir = c("s7_2a",
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

cases.dir = paste("/people/song884/dust/fy18/",cases.dir,sep="")
combined.figure.dir="/people/song884/dust/fy18/s7_all/"

combined.color = c("red","green","blue","grey","grey","grey","grey","grey",
                   "red","green","blue","grey","grey","grey","grey","grey")
combined.lty = c(1,1,1,1,1,1,1,1,
                 2,2,2,2,2,2,2,2)
legend.txt = c(expression(Low ~ K[S] ~"/"~theta[S]~"with"~k[d]~"=0"),
               expression(Mean ~ K[S] ~"/"~theta[S]~"with"~k[d]~"=0"),
               expression(High ~ K[S] ~"/"~theta[S]~"with"~k[d]~"=0"),
               expression(Hete. ~ K[S] ~"/"~theta[S]~"with"~k[d]~"=0"),
               expression(Hete. ~ K[S] ~"/"~theta[S]~"with"~k[d]~"=0"),
               expression(Hete. ~ K[S] ~"/"~theta[S]~"with"~k[d]~"=0"),
               expression(Hete. ~ K[S] ~"/"~theta[S]~"with"~k[d]~"=0"),
               expression(Hete. ~ K[S] ~"/"~theta[S]~"with"~k[d]~"=0"),                                             
               expression(Low ~ K[S] ~"/"~theta[S]~"with"~k[d]~"=0.1 cm"^3~"/g"),
               expression(Mean ~ K[S] ~"/"~theta[S]~"with"~k[d]~"=0.1 cm"^3~"/g"),
               expression(High ~ K[S] ~"/"~theta[S]~"with"~k[d]~"=0.1 cm"^3~"/g"),
               expression(Hete. ~ K[S] ~"/"~theta[S]~"with"~k[d]~"=0.1 cm"^3~"/g"),
               expression(Hete. ~ K[S] ~"/"~theta[S]~"with"~k[d]~"=0.1 cm"^3~"/g"),
               expression(Hete. ~ K[S] ~"/"~theta[S]~"with"~k[d]~"=0.1 cm"^3~"/g"),
               expression(Hete. ~ K[S] ~"/"~theta[S]~"with"~k[d]~"=0.1 cm"^3~"/g"),
               expression(Hete. ~ K[S] ~"/"~theta[S]~"with"~k[d]~"=0.1 cm"^3~"/g")
               )

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

peak.solute.list = list()
peak.year.list = list()
equi.wt.year.list = list()
equi.solute.year.list = list()
for (idir in 1:ndir)
{
    print(idir)
    load(paste(cases.dir[idir],"/results.r",sep=""))
    peak.solute.list[[idir]] = peak.solute
    peak.year.list[[idir]] = peak.year
    equi.solute.year.list[[idir]] = equi.solute.year
    equi.wt.year.list[[idir]] = equi.wt.year        
}


jpeg(filename=paste(combined.figure.dir,"combined_peak_flux.jpg",sep=""),
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
     ylim=c(0,7e6),
     axes=FALSE,
     )
box()
for (igroup in 1:groups)
{
    print(idir)
    points(0,peak.solute[[igroup]][1],pch=1)
    lines(c(0,rate),peak.solute[[igroup]],
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
mtext(expression("I-129 Flux Rate (pCi/yr/" ~ m^2 ~")"),
      2,line=1)
legend(0,7.2e6,legend.txt[1:(ndir/2)],
       lty=combined.lty,
       col=combined.color,
       lwd=2,bty="n")
legend(170,7.2e6,legend.txt[(ndir/2+1):ndir],       
       lty=combined.lty[(ndir/2+1):ndir],       
       col=combined.color[(ndir/2+1):ndir],       
       lwd=2,bty="n")
dev.off()




jpeg(filename=paste(combined.figure.dir,"combined_peak_year.jpg",sep=""),
     width = 8,height = 5,
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
for (idir in 1:ndir)
{
    print(idir)
#    points(c(0,rate),peak.year.list[[idir]],col="grey",cex=0.4)
    ##    points(0,peak.year.list[[idir]][1],pch=1)
    ## lines(c(rate),tail(peak.year.list[[idir]],-1),
    ##       col=combined.color[idir],
    ##       lwd=2,
    ##       lty=combined.lty[idir]
    ##       )
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
legend(0,2030.5,legend.txt[1:5],
       lty=combined.lty,
       col=combined.color,
       lwd=2,bty="n")
legend(170,2030.5,legend.txt[1:5+ndir/2],              
       lty=combined.lty[1:5+ndir/2],              
       col=combined.color[1:5+ndir/2],              
       lwd=2,bty="n")
dev.off()


stop()


jpeg(filename=paste(combined.figure.dir,"combined_equal_solute_year.jpg",sep=""),
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
     ylim=c(2000,3400)
     )
box()
for (idir in 1:ndir)
{
    print(idir)
    ori.rate = rate
    ori.data = tail(equi.solute.year.list[[idir]],-1)
    plot.rate = rate[1]
    plot.data = ori.data[1]
    for (irate in 2:nrate)
    {
        if(ori.data[irate]<(max(plot.data)+0.1))
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
    ## print(idir)
    ## lines(c(rate),tail(equi.solute.year.list[[idir]],-1),
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
mtext(expression("Equilibration Time (year)"),
      2,line=1)
legend(0,3400,legend.txt[1:4],
       lty=combined.lty,
       col=combined.color,
       lwd=2,bty="n")
legend(170,3400,legend.txt[1:4+ndir/2],                     
       lty=combined.lty[1:4+ndir/2],                     
       col=combined.color[1:4+ndir/2],                     
       lwd=2,bty="n")
dev.off()



legend.txt = c(expression(Low ~ K[S] ~"/"~theta[S]),
               expression(Mean ~ K[S] ~"/"~theta[S]),
               expression(High ~ K[S] ~"/"~theta[S]),
               expression(Hete. ~ K[S] ~"/"~theta[S])               
               )

jpeg(filename=paste(combined.figure.dir,"combined_equal_wt_year.jpg",sep=""),
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
     ylim=c(2035,2050),
     axes=FALSE,
     )
box()
for (idir in 1:(ndir/2))
{
    print(idir)
    ori.rate = rate
    ori.data = tail(equi.wt.year.list[[idir]],-1)
    plot.rate = rate[1]
    plot.data = ori.data[1]
    for (irate in 2:nrate)
    {
        if(ori.data[irate]>(max(plot.data)-0.1))
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
legend(0,2050,legend.txt[1:4],
       lty=combined.lty,
       col=combined.color,
       lwd=2,bty="n")
dev.off()
