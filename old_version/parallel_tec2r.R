rm(list=ls())
library(parallel)


tec2r <- function(data.file)
{
    print(data.file)
    header = readLines(data.file,n=5)
    ## find name of varis
    varis = strsplit(header[2],"\"" )[[1]]
    varis = unlist(lapply(varis,trimws))
    varis = varis[varis!=""][-1]

    ## find time
    T.line = strsplit(header[3],"," )[[1]]
    setups = list()
    for (ipair  in T.line)
    {
        iset = strsplit(ipair,"=")[[1]]
        iset = unlist(lapply(iset,trimws))
        setups[iset[1]] = iset[2]
    }

    ## find  model dimension
    num.cell = 1
    if ("I" %in% names(setups))
    {num.cell = num.cell*as.integer(setups["I"])}
    if ("J" %in% names(setups))
    {num.cell = num.cell*as.integer(setups["J"])}
    if ("K" %in% names(setups))
    {num.cell = num.cell*as.integer(setups["K"])}

    ## read all data
    data = readLines(data.file)[-c(1,2,3,4,5)]
    data=lapply(data,function (x) as.numeric(strsplit(x," ")[[1]]))
    data = unlist(data)

    ## reformat data to array of varis
    output = list()
    for (ivari in 1:length(varis))
    {
        idata  = data[(1+(ivari-1)*num.cell):(ivari*num.cell)]
        if ("I" %in% names(setups) & "J" %in% names(setups) & "K" %in% names(setups))
        {
            output[[varis[ivari]]] = array(idata,
                                    c(as.integer(setups["I"]),
                                      as.integer(setups["J"]),
                                      as.integer(setups["K"])))
        } else if  ("I" %in% names(setups) & "J" %in% names(setups) )
        {
            output[[varis[ivari]]] = array(idata,
                                    c(as.integer(setups["I"]),
                                      as.integer(setups["J"])))
        } else if  ("I" %in% names(setups) & "K" %in% names(setups) )
        {
            output[[varis[ivari]]] = array(idata,
                                    c(as.integer(setups["I"]),
                                      as.integer(setups["K"])))
        } else if  ("J" %in% names(setups) & "K" %in% names(setups) )
        {
            output[[varis[ivari]]] = array(idata,
                                    c(as.integer(setups["J"]),
                                      as.integer(setups["K"])))
        } else {
            output[[varis[ivari]]]  = idata
        }
    }

    output.file = gsub("\\.txt","\\.r",data.file)
    output.file = gsub("\\.tec","\\.r",data.file)
    output.file = gsub("\\.dat","\\.r",data.file)

    save(output,file=output.file)
}


#simu.dir="/pic/projects/dvz/xhs_simus/dust/fy18/s7_1a/"    
simu.dir = getwd()

cases = list.files(paste(simu.dir,sep=""),pattern="^r")
cases = paste(simu.dir,"/",cases,"/tec_data/",sep="")

tec_files = list()
for (icase in cases)
{
    case.files = list.files(icase,pattern="dat")
    case.files = case.files[case.files!="output.dat"]
    case.files = case.files[case.files!="surface.dat"]
    tec_files = c(tec_files,paste(icase,case.files,sep=""))
}

print(tec_files)
#lapply(tec_files,tec2r)

no.cores =  detectCores()-1
cl = makeCluster(no.cores)
clusterEvalQ(cl, sink(paste0("/people/song884/tmp/", Sys.getpid(), ".txt")))
parLapply(cl,tec_files,tec2r)
stopCluster(cl)
