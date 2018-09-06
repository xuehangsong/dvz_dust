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
    nx = as.integer(setups["I"])
    ny = as.integer(setups["J"])
    nz = as.integer(setups["K"])        
    
    ## read all data
    data = readLines(data.file)[-c(1,2,3,4,5)]
    data=lapply(data,function (x) as.numeric(strsplit(x," ")[[1]]))
    data = unlist(data)

    ## reformat data to array of varis
    output = list()

    ## xyz index
    idata  = data[1:(nx*ny*nz)]
    output[[varis[1]]] = array(idata, c(nx,ny,nz))
    idata  = data[(1+nx*ny*nz):(2*nx*ny*nz)]
    output[[varis[2]]] = array(idata, c(nx,ny,nz))
    idata  = data[(1+2*nx*ny*nz):(3*nx*ny*nz)]
    output[[varis[3]]] = array(idata, c(nx,ny,nz))


    data = data[-c(1:(3*nx*ny*nz))]
    ## other variable is cell centered
    for (ivari in 1:(length(varis)-3))
    {
        num.cell = (nx-1)*(ny-1)*(nz-1)
        idata  = data[(1+(ivari-1)*num.cell):(ivari*num.cell)]
        output[[varis[ivari+3]]] = array(idata,c(nx-1,ny-1,nz-1))
    }

    output.file = gsub("\\.txt","\\.r",data.file)
    output.file = gsub("\\.tec","\\.r",data.file)
    output.file = gsub("\\.dat","\\.r",data.file)
    save(output,file=output.file)
}

#simu.dir="/pic/projects/dvz/xhs_simus/dust/fy18/s7_1a/"    
simu.dir = getwd()

## cases = c(list.files(paste(simu.dir,sep=""),pattern="^l"),
##           ##         list.files(paste(simu.dir,sep=""),pattern="^r"),
##           list.files(paste(simu.dir,sep=""),pattern="^2018"),          
##           list.files(paste(simu.dir,sep=""),pattern="^base"))

cases = "l25"

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
