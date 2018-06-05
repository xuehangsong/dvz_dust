## collect the saturation of top layer in mutilple realizations
## to determine the upper bound of water applicaion
## written by Xuehang Song  04/12/2018

rm(list=ls())
library(RColorBrewer)
simu.dir="/pic/scratch/song884/fy2018/s7_1a/"
scripts.dir="/people/song884/dust/fy2018/s7_1a/scripts/"
figure.dir="/people/song884/dust/fy2018/s7_1a/figures/"

source(paste(scripts.dir,"parameter.R",sep=""))
nvari = 6

icase="2018"
spinup.data = read.table(
    paste(simu.dir,icase,"/tec_data/output.dat",sep=""),
    skip=3)
header = read.table(
    paste(simu.dir,icase,"/tec_data/output.dat",sep=""),
    sep='"',,
    nrow=1,skip=1)
header = header[!is.na(header)][-1]
stop()
top.satu = list()
##----------------------


legend.index = c(1,seq(25,200,25))
## cases=c("r2","r50","r100","r150","r200")
## legend.index = c(1,2,3,4,5)
colors = rainbow(length(cases),end=0.65)
names(colors) = cases
##----------------------
for (icase in c("base",cases))
{
    print(icase)
    case.data = read.table(
        paste(simu.dir,icase,"/tec_data/output.dat",sep=""),
        skip=3)
    top.satu[[icase]] = rbind(spinup.data[,1:2],case.data[,1:2])
}


jpeg(filename=paste(figure.dir,"satu_ts.jpg",sep=""),
     width = 10,height = 5,
     units = "in",res = 600, quality = 100)
par(mgp=c(2.,0.6,0),
    mar=c(3.6,3.6,1,1),
    oma=c(0,0,0,0))
icase = "base"
unique.index = match(unique(top.satu[[icase]][,1]),
                     top.satu[[icase]][,1])
plot(top.satu[[icase]][unique.index,1],
     top.satu[[icase]][unique.index,2],
     ylim=c(0,1),
     xlim=c(2010,2050),
     type="l",
     lwd=3,
     lty=2,
     xlab="Time(year)",
     ylab=expression("Saturation of Top Layer (-)")
     )
for (icase in cases)
{
    unique.index = match(unique(top.satu[[icase]][,1]),
                         top.satu[[icase]][,1])
    
    lines(top.satu[[icase]][unique.index,1],
          top.satu[[icase]][unique.index,2],
          col=colors[icase],lwd=2)

}
icase = "base"
unique.index = match(unique(top.satu[[icase]][,1]),
                     top.satu[[icase]][,1])
lines(top.satu[[icase]][unique.index,1],
      top.satu[[icase]][unique.index,2],
      col="black",lwd=3,lty=2)
arrows(2018,30000,2018,0,length=0.15,angle=15,code=2,
       col="black")
legend("topright",c("base",cases[legend.index]),
       lty=c(2,rep(1,length(legend.index))),
       col=c("black",colors[legend.index]),bty="n",
       lwd=c(3,rep(2,length(legend.index))))       

dev.off()

max.satu  = c()
for (icase in c("base",cases))
{
    print(icase)
    max.satu = c(max.satu,max(top.satu[[icase]][,2]))
}
names(max.satu) = c("base",cases)
print(names(max.satu[which(max.satu>=1)]))
##r312 s7_1a6
##r398 s7_1a7
####r400=0.980998 s7_1a8
