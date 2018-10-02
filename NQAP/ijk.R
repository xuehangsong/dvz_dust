#This program generates STOMP ijk-indexed porosity and hydraulic conductivity files for all material types and inserts heterogeneous hydraulic conductivity 
#and porosity fields into CCUz 
#This program also generates STOMP input formatted files for saturation parameters -- a requirement of STOMP for using IJK-index porosity and permeabilities. 
setwd('/Users/rupr404/Desktop/GSLIB_bin')
options(stringsAsFactors = FALSE)
rm(list=ls(all=TRUE))
#
#Step 0: Initialize
  #Read in CCUz properties output by IDW_nk.R
  n=read.csv('ns.txt', header=F)
  k=read.csv('ks.txt', header=F)
  #Read in geology
    #note: Set up s7_mat.txt outside of this program by copying and pasting from the input file:
    #Number of X-Direction Grid Cells, Number of Y-Direction Grid Cells, Number of Z-Direction Grid Cells,
    #Number of Rock/Soil Zonation Domains
    # Repeat for each Rock/Soil Zonation Domain: Rock/Soil Name,I Start,I End,J Start,J End,K Start,K End,
    # Repeat for each rock/soil type: Rock/Soil Name,Grain or Particle Density,Units(kg/m^3),Total Porosity,Diffusive Porosity,Compressibility,Bulk Compressibility,Units(1/Pa),Reference Pressure,Units(Pa),
    # Repeat for each rock/soil type: Rock/Soil Name,X-Direction Hydraulic Conductivity,hc:Units(m/s),Y-Direction Hydraulic Conductivity,hc:Units(m/s),Z-Direction Hydraulic Conductivity,hc:Units(m/s),
    # Repeat for each Rock/Soil Type: Rock/Soil Name,van Genuchten,α Parameter,Units(1/m),n Parameter,Minimum Saturation,m Parameter(Optional), 
  mat=read.csv('s7_mat.txt', header=F)
#
#Step 1: Convert perm to hydraulic conductivity -- m2 to m/s
  #where hyd conductivity = perm*(water density)*gravity / viscosity of water
  k<-(10.^k)*997.*9.8/0.00089
  #
  #convert to cm/s
  k<-k*100. 
#
#Step 2: set up empty ijk list to fill in later
  iimax=as.numeric(mat[1,1])
  jjmax=as.numeric(mat[1,2])
  kkmax=as.numeric(mat[1,3])
  ijk_n=array(0, iimax*jjmax*kkmax)
  ijk_k=ijk_n
  ijk_sat1=ijk_n
  ijk_sat2=ijk_n
  ijk_sat3=ijk_n
#
#Step 3: assign count of how many rock types there are in the s7_mat.txt 
  count=as.numeric(mat[2,1])
#
#Step 4: assign porosity and hydraulic conductivities by rock type
  #initialize
  i=1
  ijk_max_old=as.numeric(mat[3,2])*as.numeric(mat[3,4])*as.numeric(mat[3,6])
  #for each rock type
  for (i in 1:count){
    imax=as.numeric(mat[i+2,3])
    jmax=as.numeric(mat[i+2,5])
    kmax=as.numeric(mat[i+2,7])
    #how many values are needed to be specified for each rock type (I End * J End * K End)
    ijk_max=imax*jmax*kmax
    #
    #Create lisijk-indexed lists of porosity, permeability, and saturation card parameters
    #If the material is CCUz, use heterogeneous properties, otherwise use the same value everywhere
    if(mat[i+2,1]=="CCUz"){
      ijk_n[ijk_max_old:ijk_max]=n[,1]
      ijk_k[ijk_max_old:ijk_max]=k[,1]
      ijk_sat1[ijk_max_old:ijk_max]=array(as.numeric(mat[2+count*3+i,3]))
      ijk_sat2[ijk_max_old:ijk_max]=array(as.numeric(mat[2+count*3+i,5]))
      ijk_sat3[ijk_max_old:ijk_max]=array(as.numeric(mat[2+count*3+i,6]))
    }else{
      ijk_n[ijk_max_old:ijk_max]=array(as.numeric(mat[2+count+i,4]))
      ijk_k[ijk_max_old:ijk_max]=array(as.numeric(mat[2+count*2+i,2]))
      ijk_sat1[ijk_max_old:ijk_max]=array(as.numeric(mat[2+count*3+i,3]))
      ijk_sat2[ijk_max_old:ijk_max]=array(as.numeric(mat[2+count*3+i,5]))
      ijk_sat3[ijk_max_old:ijk_max]=array(as.numeric(mat[2+count*3+i,6]))
      
    }
    #keep count of where we are in the ijk-indexing 
    ijk_max_old=ijk_max+1.
  }
write.table(ijk_n,file="ijk_n.txt", row.names = F, col.names = F)
write.table(ijk_k,file="ijk_k.txt", row.names = F, col.names = F)
write.table(ijk_sat1,file="ijk_sat1.txt", row.names = F, col.names = F)
write.table(ijk_sat2,file="ijk_sat2.txt", row.names = F, col.names = F)
write.table(ijk_sat3,file="ijk_sat3.txt", row.names = F, col.names = F)
