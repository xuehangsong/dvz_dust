##create inputfiles for s7_1a
##wrote by Xuehang Song, 04/03/2018
rm(list=ls())

scripts.dir="/people/song884/dust/fy2018/s7_1a7/scripts/"
simu.dir = "/pic/scratch/song884/fy2018/s7_1a7/"
setwd(simu.dir)

source(paste(scripts.dir,"parameter.R",sep=""))

template = readLines(paste("r2/input",sep=""))
for (irate in 2:nrate)
{
    print(irate)
    if(!dir.exists(paste("r",rate[irate],sep="")))
    {
        dir.create((paste("r",rate[irate],sep="")))

    }
    Sys.chmod((paste("r",rate[irate],sep="")),"700")        

    template.rate = base.rate+rate[1]*(365*3+366)/4
    year.rate = base.rate+rate[irate]*(365*3+366)/4

    output = gsub(template.rate,year.rate,template)
    writeLines(output,paste("r",rate[irate],"/input",sep=""))
}

template = readLines(paste("l2/input",sep=""))
for (irate in 2:nrate.l)
{
    print(irate)
    if(!dir.exists(paste("l",rate.l[irate],sep="")))
    {
        dir.create((paste("l",rate.l[irate],sep="")))

    }
    Sys.chmod((paste("l",rate.l[irate],sep="")),"700")        

    template.rate = base.rate+rate.l[1]*(365*3+366)/4
    year.rate = base.rate+rate.l[irate]*(365*3+366)/4

    output = gsub(template.rate,year.rate,template)
    writeLines(output,paste("l",rate.l[irate],"/input",sep=""))
}
