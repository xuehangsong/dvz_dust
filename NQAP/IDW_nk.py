import numpy as np
import os
import matplotlib.pyplot as plt
from scipy.interpolate import Rbf

"""
this script is for reproduce results of the R scripts NandK_trans.R
09/26/2018
"""

os.chdir("/people/song884/dust/fy18/NQAP/")

# INPUTS
# note: Set up grid* files outside of this program by creating arrays of all x, y, z nodes (middle of gridblocks).
# define STOMP grid
sx = np.loadtxt('grid_x.csv', skiprows=1)
sy = np.loadtxt('grid_y.csv', skiprows=1)
sz = np.loadtxt('grid_z.csv', skiprows=1)
n_sx = len(sx)
n_sy = len(sy)
n_sz = len(sz)

s_grids = np.asarray([(x, y, z) for z in sz for y in sy for x in sx])
# define GSLIB grid
gx = np.loadtxt('grid_gslib_x.csv', skiprows=1)
gy = np.loadtxt('grid_gslib_y.csv', skiprows=1)
gz = np.loadtxt('grid_gslib_z.csv', skiprows=1)
n_gx = len(gx)
n_gy = len(gy)
n_gz = len(gz)

g_grids = np.asarray([(x, y, z) for z in gz for y in gy for x in gx])
#
#
# REFORMAT PARAMETER DATA TO IJK-INDEXING
dfn = np.loadtxt('n_CCUZ.txt')
#
tdfn = dfn.reshape(n_gx, n_gy, n_gz, order="F")

# read in GSLIB log permeability, I-indexed
dfk = np.loadtxt('logk_CCUZ.txt')
#dfk = 10**dfk
tdfk = dfk.reshape(n_gx, n_gy, n_gz, order="F")

p = 2.
lmt = 5.
n_avg = 0.2
ns = np.full((n_sx, n_sy, n_sz), n_avg)

k_avg = 2.e-12
ks = np.full((n_sx, n_sy, n_sz), k_avg)

#
#
# CALCULATE WEIGHTS FOR IDW
#
# Step 1: Systematically loop through STOMP gridblocks and identify which GSLIB gridblocks are nearby.
# Loop around STOMP x-discretizations, note: only condsidering lateral correlations
for i in range(n_sx):
    # Loop around GSLIB x-discretizations (gx)
    for ii in range(n_gx):
        # If the distance between the GSLIB node of interest and the STOMP node of interest is less than the distance limit, keep going
        dist0 = abs(gx[ii]-sx[i])
        if dist0 < lmt:
            # Loop around STOMP y-discretizations (sy)
            for j in range(n_sy):
                # Initialize interpolative terms for new point, where the interpolated value will equal ns_top/ns_bot
                # See Step 4 below for how these are used
                ns_top = 0.
                ns_bot = 0.
                ks_top = 0.
                ks_bot = 0.
                # loop around GSLIB y-discretizations (gy)
                for jj in range(n_gy):
                    # if the distance between the GSLIB node of interest and the STOMP node of interest is less than the limit, keep going
                    if abs(gy[jj]-sy[j]) < lmt:
                        # calculate the total distance
                        dist = np.sqrt((sx[i]-gx[ii])**2+(sy[j]-gy[jj])**2)
                        #
                        # Step 2: Caluclate the distance weighting factor
                        if dist > 0.:
                            wt = 1./(dist ** p)
                        else:
                            wt = 1.e6
                        #
                        # Step 3:Set n and k equal to the porosity and permeability of the GSLIB node
                        n = tdfn[ii, jj, :]
                        k = tdfk[ii, jj, :]
                        #
                        # Step 4a: Set the interpolated value top terms (ns_top, ks_top) equal to the sum of
                        ns_top = ns_top+(wt*n)
                        ks_top = ks_top+(wt*k)
                        #
                        # Step 4b: Set the interpolated value bot terms (ns_top, ks_top) to the sum of the weights
                        ns_bot = ns_bot+wt
                        ks_bot = ks_bot+wt
                        #
                        # Step 5: Solve for the interpolated value of porosity, ns, and permeability, ks.
                        ns[i, j, :] = ns_top/ns_bot
                        ns[i, j, :] = ns[i, j, :]
                        ks[i, j, :] = ks_top/ns_bot
                        ks[i, j, :] = ks[i, j, :]


np.savetxt("ns_py.txt", ns.flatten(order="F"))
np.savetxt("ks_py.txt", ks.flatten(order="F"))
# REFORMAT
# ns = t(as.vector(ns))
# ns = t(ns)
# write.table(ns, file="ns.txt", row.names=F, col.names=F)
# ks = t(as.vector(ks))
# ks = t(ks)
# write.table(ks, file="ks.txt", row.names=F, col.names=F)
# # np.savetxt("logk_CCUZ_py.txt", dfn)
