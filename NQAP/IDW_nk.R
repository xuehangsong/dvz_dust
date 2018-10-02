#This program maps the uniform GSLIB grid to the nonuniform STOMP grid using inverse distance weighting
setwd('/Users/rupr404/Desktop/GSLIB_bin')
options(stringsAsFactors = FALSE)
rm(list=ls(all=TRUE))
#INPUTS
  #note: Set up grid* files outside of this program by creating arrays of all x, y, z nodes (middle of gridblocks). 
  #define STOMP grid
  sx=read.csv('grid_x.csv', header=F)
  sx=t(sx)
  sy=read.csv('grid_y.csv', header=F)
  sy=t(sy)
  sz=read.csv('grid_z.csv', header=F)
  sz=t(sz)
  #define GSLIB grid
  gx=read.csv('grid_gslib_x.csv', header=F)
  gx=t(gx)
  gy=read.csv('grid_gslib_y.csv', header=F)
  gy=t(gy)
  gz=read.csv('grid_gslib_z.csv', header=F)
  gz=t(gz)
  #
  #
#REFORMAT PARAMETER DATA TO IJK-INDEXING
  #read in GSLIB porosity, I-indexed
  dfn<-read.csv('n_CCUZ.txt', header=F)
  #transpose dataset
  tdfn<-t(dfn)
  #reformat in 3d (ijk-indexing) based on the dimensions of the GSLIB grid
  dim(tdfn)=c(length(gx),length(gy),length(gz))
  #
  #read in GSLIB log permeability, I-indexed
  dfk<-read.csv('logk_CCUZ.txt', header=F)
  #convert from logk to k
  dfk<-10.^dfk
  #transpose dataset
  tdfk<-t(dfk)
  #reformat in 3d (ijk-indexing) based on the dimensions of the GSLIB grid
  dim(tdfk)=c(length(gx),length(gy),length(gz))
  #
  #
#SET UP INVERSE DISTANCE WEIGHTING (IDW)
  #this is a known method, here is one such source: http://www.ncgia.ucsb.edu/pubs/spherekit/inverse.html
  #
  #Step 1: Specify p -- The most common choice is p=2 -- where p>0. 
  p=2.
  #
  #Step 2: Specify neighborhood size
  #The neighborhood size determines how many points are included in the inverse distance weighting. 
  #The neighborhood size can be specified in terms of its radius, the number of points, or a combination of the two. 
  #Here, we use a radius to match largest STOMP gridblock spacing in m. 
  lmt=5.
  #
  #Step 3: Set dummy avg porosity everywhere
  n_avg=0.2
  #Step 4: Initialize interpolated value matrix based on the STOMP grid 
  ns=array(n_avg,length(sx)*length(sy)*length(sz))
  #Step 5: Dimension to match STOMP grid
  dim(ns)=c(length(sx),length(sy),length(sz))
  #
  #Step 6: Set dummy avg permeability everywhere
  k_avg=2.e-12
  #
  #Step 7: Initialize interpolated value matrix based on the STOMP grid 
  ks=array(k_avg,length(sx)*length(sy)*length(sz))
  #
  #Step 8: Dimension to match STOMP grid
  dim(ks)=c(length(sx),length(sy),length(sz))
#
#
#CALCULATE WEIGHTS FOR IDW
  #
  #Step 1: Systematically loop through STOMP gridblocks and identify which GSLIB gridblocks are nearby.  
    #Loop around STOMP x-discretizations, note: only condsidering lateral correlations
    for (i in 1:length(sx)){
      #Loop around GSLIB x-discretizations (gx)
      for (ii in 1:length(gx)){               
        #If the distance between the GSLIB node of interest and the STOMP node of interest is less than the distance limit, keep going
        dist0=abs(gx[ii]-sx[i])
        if (dist0<lmt){
          #Loop around STOMP y-discretizations (sy)
          for(j in 1:length(sy)){
            #Initialize interpolative terms for new point, where the interpolated value will equal ns_top/ns_bot
            #See Step 4 below for how these are used 
            ns_top=0.
            ns_bot=0.
            ks_top=0.
            ks_bot=0.
            #loop around GSLIB y-discretizations (gy)
            for(jj in 1:length(gy)){
              #if the distance between the GSLIB node of interest and the STOMP node of interest is less than the limit, keep going
              if (abs(gy[jj]-sy[j])<lmt){
                #calculate the total distance
                dist=sqrt((sx[i]-gx[ii])^2+(sy[j]-gy[jj])^2)
                  #
                  #Step 2: Caluclate the distance weighting factor
                    #If the distance between the GSLIB node of interest and the STOMP node of interest is greater than 0, 
                    #perform IDW (1./(distance^p)) to determine weighting factor for gslib parameter value. 
                    #If the distance is 0, the nodes align and GSLIB values are heavily weighted.
                    if(dist>0.){wt=1./(dist^p)}else{wt=1.e6}
                    #      
                    #Step 3:Set n and k equal to the porosity and permeability of the GSLIB node 
                        n=tdfn[ii,jj,]
                        k=tdfk[ii,jj,]
                          #
                          #Step 4a: Set the interpolated value top terms (ns_top, ks_top) equal to the sum of 
                            # porosities, permabilities of the GSLIB params multiplied by the distance weighting factor
                              #Shepard's Method: "A two-dimensional interpolation function for irregularly-spaced data". 
                              #Proceedings of the 1968 ACM National Conference. pp. 517–524. 
                            ns_top=ns_top+(wt*n)
                            ks_top=ks_top+(wt*k)                
                            #
                            #Step 4b: Set the interpolated value bot terms (ns_top, ks_top) to the sum of the weights
                            ns_bot=ns_bot+wt
                            ks_bot=ks_bot+wt
                              #
                              #Step 5: Solve for the interpolated value of porosity, ns, and permeability, ks. 
                              ns[i,j,]=ns_top/ns_bot
                              ns[i,j,]=ns[i,j,]
                              ks[i,j,]=ks_top/ns_bot
                              ks[i,j,]=ks[i,j,]
                          }
                        }
                      }
                    }
                  }
                }
#REFORMAT
ns<-t(as.vector(ns))
ns<-t(ns)
write.table(ns,file="ns.txt", row.names = F, col.names = F)
ks<-t(as.vector(ks))
ks<-t(ks)
write.table(ks,file="ks.txt", row.names = F, col.names = F)