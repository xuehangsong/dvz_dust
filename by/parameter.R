## Cartesian,
## 65,68,173,
## 573450.0,m,21@5,m,3@4,m,2@4.4,m,4@3.1,m,1@4.3,m,5@4.4,m,1@4.3,m,4@3.1,m,2@4.4,m,22@5,m,
## 137520.0,m,16@5,m,2@4.4,m,4@3.1,m,3@4.2,m,4@3.1,m,3@4.2,m,4@3.1,m,3@4.2,m,4@3.1,m,2@4.4,m,23@5,m,
## 120,m,11@1,m,4@0.5,m,4@0.25,m,2@0.5,m,6@1,m,120@0.25,m,18@1,m,3@0.5,m,5@1,m,


rate = 2*(1:250)
rate.l = c(2,seq(50,500,50))

base.rate = 3

nrate = length(rate)
nrate.l = length(rate.l)

cases = paste("r",rate,sep="")
ncase = length(cases)

cases.l = paste("l",rate.l,sep="")
nrate.l = length(cases.l)

dx=c(rep(5,21),
     rep(4,3),
     rep(4.4,2),
     rep(3.1,4),
     rep(4.3,1),
     rep(4.4,5),
     rep(4.3,1),
     rep(3.1,4),
     rep(4.4,2),
     rep(5,22))

dy=c(rep(5,16),
     rep(4.4,2),
     rep(3.1,4),
     rep(4.2,3),
     rep(3.1,4),
     rep(4.2,3),
     rep(3.1,4),
     rep(4.2,3),
     rep(3.1,4),
     rep(4.4,2),
     rep(5,23))

dz=c(rep(1,11),
     rep(0.5,4),
     rep(0.25,4),
     rep(0.5,2),
     rep(1,6),
     rep(0.25,120),
     rep(1,18),
     rep(0.5,3),
     rep(1,5))

nx=length(dx)
ny=length(dy)
nz=length(dz)

x=cumsum(c(573450.0,dx))
y=cumsum(c(137520.0,dy))
z=cumsum(c(120,dz))

range.x = range(x)
range.y = range(y)
range.z = range(z)

lx = diff(range.x)
ly = diff(range.y)
lz = diff(range.z)

crib.ix = 25:43
crib.iy = 17:45
crib.area = sum(dx[crib.ix])*sum(dy[crib.iy])
crib.range.x = x[range(crib.ix-1,crib.ix)]
crib.range.y = y[range(crib.iy-1,crib.iy)]
