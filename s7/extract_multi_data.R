rm(list=ls())
cases.dir = c("s7_2a",
              "s7_1a",
              "s7_3a",
              "s7_4a",
              "s7_5a",                            
              "s7_2b",
              "s7_1b",
              "s7_3b",
              "s7_4b",              
              "s7_5b")
cases.dir = paste("/people/song884/dust/fy2018/",cases.dir,sep="")
combined.figure.dir="/people/song884/dust/fy2018/s7_all/"

combined.color = c("red","green","blue","grey","grey",
                   "red","green","blue","grey","grey")
combined.lty = c(1,1,1,1,1,
                 2,2,2,2,2)
legend.txt = c(expression(Low ~ K[S] ~"/"~theta[S]~"with"~k[d]~"=0"),
               expression(Mean ~ K[S] ~"/"~theta[S]~"with"~k[d]~"=0"),
               expression(High ~ K[S] ~"/"~theta[S]~"with"~k[d]~"=0"),
               expression(Hete. ~ K[S] ~"/"~theta[S]~"with"~k[d]~"=0"),
               expression(Hete. ~ K[S] ~"/"~theta[S]~"with"~k[d]~"=0"),                              
               expression(Low ~ K[S] ~"/"~theta[S]~"with"~k[d]~"=0.1 cm"^3~"/g"),
               expression(Mean ~ K[S] ~"/"~theta[S]~"with"~k[d]~"=0.1 cm"^3~"/g"),
               expression(High ~ K[S] ~"/"~theta[S]~"with"~k[d]~"=0.1 cm"^3~"/g"),
               expression(Hete. ~ K[S] ~"/"~theta[S]~"with"~k[d]~"=0.1 cm"^3~"/g"),
               expression(Hete. ~ K[S] ~"/"~theta[S]~"with"~k[d]~"=0.1 cm"^3~"/g")               
               )
ndir = length(cases.dir)

peak.solute.list = list()
peak.year.list = list()
for (idir in 1:ndir)
{
    print(idir)
    load(paste(cases.dir[idir],"/results.r",sep=""))
    peak.solute.list[[idir]] = peak.solute
    peak.year.list[[idir]] = peak.year
}

jpeg(filename=paste(combined.figure.dir,"combined_peak_flux_extract_data.jpg",sep=""),
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
     ylim=c(0,7e6),
     axes=FALSE,
     )
box()
for (idir in 1:ndir)
{
    print(idir)
    points(0,peak.solute.list[[idir]][1],pch=1)
    lines(c(0,rate),peak.solute.list[[idir]],
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
legend(0,7.2e6,legend.txt[1:4],
       lty=combined.lty,
       col=combined.color,
       lwd=2,bty="n")
legend(170,7.2e6,legend.txt[1:4+ndir/2],       
       lty=combined.lty[1:4+ndir/2],       
       col=combined.color[1:4+ndir/2],       
       lwd=2,bty="n")
dev.off()




legend.txt = c("low with Kd=0",
               "mean with Kd=0",
               "high with Kd=0",               
               "hete1 with Kd=0",
               "hete2 with Kd=0",
               "low with Kd=0.1 cm3/g",
               "mean with Kd=0.1 cm3/g",
               "high with Kd=0.1 cm3/g",
               "hete1 with Kd=0.1 cm3/g",
               "hete2 with Kd=0.1 cm3/g")
               
data.output = as.data.frame(peak.solute.list)
data.output = cbind(c(0,rate),
                    c(0,rate*crib.area/1000*264.172/24/60),
                    c(0,rate*crib.area/1000/15.14165),
                    data.output)
colnames(data.output) = c("Water Application Rate (mm/day)",
                          "Applied Water Volume (gal/min)",
                          "Truckloads/day (1 truck = 4000 gal)",
                          legend.txt
                          )
write.csv(data.output,"~/i129_flux.csv")
