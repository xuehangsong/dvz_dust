rm(list=ls())

user = "song884"
jobs = system(paste("squeue -u", user),intern=TRUE)
jobs = jobs[-1]
jobs = gsub(" * "," ",jobs)
jobs = strsplit(jobs," ")

ids = as.numeric(lapply(jobs,"[[",2))
ori.queue = as.character(lapply(jobs,"[[",3))
