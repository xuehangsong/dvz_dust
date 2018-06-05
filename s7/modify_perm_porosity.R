### this scripts is to change the permeablity
## and porosity of certain sediments
## here is to change cold creek
## 04/07/2018 written by Xuehang
## tips: please check the revised input to ensure the
## implementation is right


rm(list=ls())
library(RColorBrewer)

sediments = "CCUZ"
old.values = c("0.350","7.27E-06")
new.values = c("0.350","7.27E-06")  ## 1a, 1b
new.values = c("0.300","7.27E-07")  ## 2a, 2b
new.values = c("0.400","7.27E-05")  ## 3a, 3b 

simu.dir="/pic/scratch/song884/fy2018/s7_2a/"
scripts.dir="/people/song884/dust/fy2018/s7_2a/scripts/"
figure.dir="/people/song884/dust/fy2018/s7_2a/figures/"

cases = list.dirs(simu.dir,full.names=FALSE)
cases = cases[which(cases>0)]

for (icase in cases)
{
    print(icase)
    input = readLines(paste(simu.dir,icase,"/input",sep=""))
    sedi.index = grep("CCUz",input)
    for (i.sedi.index in sedi.index)
    {
        for (i.value in 1:length(old.values))
        {
            input[i.sedi.index] = gsub(old.values[i.value],
                                        new.values[i.value],
                                        input[i.sedi.index])
        }

    }
    writeLines(input,paste(simu.dir,icase,"/input",sep=""))
}
