##  define the model

## r* cases: realizatons
## l* cases: addtional realizations with more frequent snapshot file output

## /rate/ cases: realizatons
## /rate.l/ cases: addtional realizations with more frequent snapshot file output
## written by Xuehang Song 03/03/2018
## revised by Xuehang Song 04/09/2018

rate = 2*(1:200)
rate.l = c(2,seq(50,400,50))


base.rate = 44

nrate = length(rate)
nrate.l = length(rate.l)

cases = paste("r",rate,sep="")
ncase = length(cases)

cases.l = paste("l",rate.l,sep="")
nrate.l = length(cases.l)

dx=c(rep(5,10),
     rep(2.5,10),
     rep(1.95,5),
     rep(3.05,10),
     rep(1.95,5),
     rep(2.5,10),
     rep(5,10),
     rep(10,40),
     rep(50,10))


dy=c(rep(10,45),
     rep(3,10),
     rep(2.0,5),
     rep(3.4,1),
     rep(3.04,2),
     rep(1,1),
     rep(0.52,1))

dz=c(rep(1,10),
     rep(0.5,6),
     rep(1,67))

nx=length(dx)
ny=length(dy)
nz=length(dz)

x=cumsum(c(0,dx))
y=cumsum(c(0,dy))
z=cumsum(c(124.2,dz))

range.x = range(x)
range.y = range(y)
range.z = range(z)

lx = diff(range.x)
ly = diff(range.y)
lz = diff(range.z)

crib.ix = 27:37
crib.iy = 61:65
crib.area = sum(dx[crib.ix])*sum(dy[crib.iy])
crib.range.x = x[range(crib.ix-1,crib.ix)]
crib.range.y = y[range(crib.iy-1,crib.iy)]

con.inj.ix = 26:35
con.inj.iy = 62:63
con.inj.iz = 78:78
con.inj.area = sum(dx[con.inj.ix])*sum(dy[con.inj.iy])

material = array(NA,c(10,2))
material[1,] = c(1,17)
material[2,] = c(18,31)
material[3,] = c(32,37)
material[4,] = c(38,38)
material[5,] = c(39,46)
material[6,] = c(47,60)
material[7,] = c(61,64)
material[8,] = c(65,69)
material[9,] = c(70,77)
material[10,] = c(78,83)

rownames(material) = c("RG-SAT", "Rwie", "Rtf",
                       "CCUc","CCUz","H2-fs",
                       "H2-cs","H1-g","H1-cs",
                       "Backfill")

#z[material[1:9,2]]
