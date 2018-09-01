## collect data from the tecplot

rm(list=ls())

#simu.dir="/pic/projects/dvz/xhs_simus/dust/fy18/by_1a/"
simu.dir="./"

scripts.dir="/people/song884/github/dvz_dust/by/"

# load model parameters
source(paste(scripts.dir,"parameter.R",sep=""))

# list all cases files
cases = c(#list.files(paste(simu.dir,sep=""),pattern="^r"),
          list.files(paste(simu.dir,sep=""),pattern="^l"),
          list.files(paste(simu.dir,sep=""),pattern="^2018$"),          
          list.files(paste(simu.dir,sep=""),pattern="^base$"))
          
# point to tecplot files
cases.dir = paste(simu.dir,"/",cases,"/tec_data/",sep="")

satu.name = "Aqueous Saturation"
solute.name = "Aqueous no3 Concentration, 1/l"

## caculate cell area
dx.grids = rep(dx,ny)
dy.grids = rep(dy,each=nx)
cell.areas = array(dx.grids*dy.grids,c(nx,ny))

# generate mean solute concentration and maximum solute concentration
solute.conc = list()
for (icase in 1:length(cases))
{
    print(cases[icase])
    
    solute.conc[[cases[icase]]] = c()
    r.files = list.files(cases.dir[icase],pattern="\\.r")
    r.files = r.files[!is.na(as.numeric(gsub(".r","",r.files)))]    
    r.files = c(paste(cases.dir[icase],r.files,sep=""))
    for (ifile in r.files)
    {
         # load file, read,time
        time = as.numeric(tail(strsplit(gsub("\\.r","",ifile),"/")[[1]],1))
        load(ifile)

        # fined the watertable
        wt.iz = min(which(output[satu.name][[1]]<0.99999999,arr.ind=TRUE)[,3])-1
        solute.xy = output[solute.name][[1]][,,wt.iz]

        # caculate the mean concentration
        domain.mean = mean(solute.xy*cell.areas/sum(cell.areas))
        crib.mean = mean(solute.xy[crib.ix,crib.iy]*cell.areas[crib.ix,crib.iy]/sum(cell.areas[crib.ix,crib.iy]))
        domain.max = max(solute.xy)
        crib.max = max(solute.xy[crib.ix,crib.iy])

        # generate solute concentration files
        solute.conc[[cases[icase]]] = rbind(solute.conc[[cases[icase]]],
                                             c(time,
                                               domain.mean,
                                               crib.mean,
                                               domain.max,
                                               crib.max))

    }
    colnames(solute.conc[[cases[icase]]]) = c("time","domain.mean","crib.mean","domain.max","crib.max")
    
}
save(solute.conc,file=paste(simu.dir,"solute_conc.r",sep=""))

## rates = unlist(lapply(names(mean.solutes),function (x) as.integer(substring(x,2,))))
## rates = sort(rates)


## colors = rainbow(length(rates),end=0.65)
## mean.index = 2
## y.max = max(unlist(lapply(mean.solutes,function (x) max(x[,mean.index]))))
## irate = rates[1]
## icase = paste("l",toString(irate),sep="")
## plot(mean.solutes[[icase]][,1],
##      mean.solutes[[icase]][,mean.index],
##      ylim = c(0,y.max),
##      ylab = "I-129 (pCi/L)",
##      xlab = "Time (yr)",
##      type="l")
## for (irate in 1:length(rates))
## {
##     print(irate)
##     icase = paste("l",toString(rates[irate]),sep="")
##     lines(mean.solutes[[icase]][,1],
##           mean.solutes[[icase]][,mean.index],
##           col = colors[irate],
##           type="l")
## }
## legend("topright",
##        unlist(lapply(rates,toString)),
##        col=colors,
##        lwd=1,
##        lty=1,
##        bty="n"
##        )


## filled.contour(x[-1]-0.5*dx,
##                y[-1]-0.5*dy,
##                solute.xy,
##                asp=1,
##                ## axis(1),
##                ## axis(2),
##                key.title="",
##                plot.axes={rect(x[min(crib.ix)],
##                                y[min(crib.iy)],
##                                x[1+max(crib.ix)],
##                                y[1+max(crib.iy)])
##                                axis(1)
##                                axis(2)
##                                xlim=c(0,1200)
##                                ylim=c(0,500)

##                })
