### this scripts is to change the permeablity
## and porosity of certain sediments
## here is cold creek
## 04/07/2018 written by Xuehang
## please check the revised input to ensure the
## implement is right


rm(list=ls())
library(RColorBrewer)

sediments = "CCUZ"
old.values = c("0.350","7.27E-06")
new.values = c("0.350","7.27E-06")

simu.dir="/pic/scratch/song884/fy2018/s7_1a7/"
scripts.dir="/people/song884/dust/fy2018/s7_1a7/scripts/"
figure.dir="/people/song884/dust/fy2018/s7_1a7/figures/"

cases = list.dirs(simu.dir,full.names=FALSE)
cases = cases[which(cases>0)]

for (icase in cases)
{
    print(icase)
    input = readLines(paste(simu.dir,icase,"/input",sep=""))
    ## sedi.index = grep("CCUz",input)
    ## for (i.sedi.index in sedi.index)
    ## {
    ##     for (i.value in 1:length(old.values))
    ##     {
    ##         input[i.sedi.index] = gsub(old.values[i.value],
    ##                                     new.values[i.value],
    ##                                     input[i.sedi.index])
    ##     }

    ## }
    writeLines(input,paste(simu.dir,icase,"/input",sep=""))
}
