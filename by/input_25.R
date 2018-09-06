##create inputfiles for s7_1a
##written by Xuehang Song, 04/03/2018
##modified by Xuehang Song, 04/30/2018
rm(list=ls())

simu.dir = "/pic/projects/dvz/xhs_simus/dust/fy18/by_10a/"

scripts.dir="/people/song884/github/dvz_dust/by/"
setwd(simu.dir)

source(paste(scripts.dir,"parameter.R",sep=""))

template = readLines(paste("l2/input",sep=""))
for (irate in 2)
{
    print(irate)
    if(!dir.exists(paste("l",rate.l[irate],sep="")))
    {
        dir.create((paste("l",rate.l[irate],sep="")))

    }
    Sys.chmod((paste("l",rate.l[irate],sep="")),"700")        

    ##system(paste("cp -p l2/nonuniform-zonation-by l",rate.l[irate],sep=""))        
    ##system(paste("cp -p l2/restart.hdf5 l",rate.l[irate],sep=""))    
    system(paste("cp -p l2/*txt l",rate.l[irate],sep=""))
    
    template.rate = base.rate+rate.l[1]*(365*3+366)/4
    year.rate = base.rate+rate.l[irate]*(365*3+366)/4

    output = gsub(template.rate,year.rate,template)
    writeLines(output,paste("l",rate.l[irate],"/input",sep=""))
}
