rm(list=ls())

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
            output[[ivari]] = array(idata,
                                    c(as.integer(setups["I"])-1,
                                      as.integer(setups["J"])-1,
                                      as.integer(setups["K"])-1))
        } else if  ("I" %in% names(setups) & "J" %in% names(setups) )
        {
            output[[ivari]] = array(idata,
                                    c(as.integer(setups["I"])-1,
                                      as.integer(setups["J"])-1))
        } else if  ("I" %in% names(setups) & "K" %in% names(setups) )
        {
            output[[ivari]] = array(idata,
                                    c(as.integer(setups["I"])-1,
                                      as.integer(setups["K"])-1))
        } else if  ("J" %in% names(setups) & "K" %in% names(setups) )
        {
            output[[ivari]] = array(idata,
                                    c(as.integer(setups["J"])-1,
                                      as.integer(setups["K"])-1))
        } else {
            output[[ivari]] = idata
        }
    }

    ## output.file = gsub("\\.txt","\\.r",data.file)
    ## output.file = gsub("\\.tec","\\.r",data.file)
    ## output.file = gsub("\\.dat","\\.r",data.file)

    ## save(output,file=output.file)
}



data.file = "/pic/projects/dvz/xhs_simus/dust/fy18/s7_1a/l2/tec_data/2018.66.dat"
tec2r(data.file)
