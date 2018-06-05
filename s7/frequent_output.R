rm(list=ls())

times = seq(2018,2030,30/365.25)
times = c(times,2030:2099)
times = c(times,seq(2100,3000,100))

###times = c(c(2018,2020,2022,2024,2030,2050,2100,3000),times)
times = sort(unique(times))


times = seq(1955,2018,0.5)
data = paste(sprintf("%1.7f",times),",yr,",sep="")
write.table(data,file="times.dat",row.names=FALSE,col.names=FALSE,quote=FALSE)
print(length(data))


