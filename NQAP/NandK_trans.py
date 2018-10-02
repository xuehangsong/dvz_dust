import numpy as np
import os
import matplotlib.pyplot as plt
"""
this script is for reproduce results of the R scripts NandK_trans.R
09/26/2018
"""

os.chdir("/people/song884/dust/fy18/NQAP/")
df = np.loadtxt("nn.csv", skiprows=3)

# for porosity
# back transform from std normal scores to normal porosity values
# Std_dev and porosity taken from Truex et al., (2017) report (PNNL-24709, Rev. 2; RPT-DVZ-AFRI-030, Rev. 2).
stddev_n = -0.1
# set n-avg to 1 minus the average
n_avg = 1-0.35
dfn = -df*stddev_n+n_avg
dfn = 1-dfn
dfn = np.abs(dfn)
tdfn = dfn.reshape(1100, 501*8)

np.savetxt("n_CCUZ_py.txt", dfn)

fig = plt.figure()
ax = fig.add_subplot(111)
ax.hist(dfn, bins=np.arange(0, 0.82, 0.05))
ax.ticklabel_format(style="sci", axis="y", scilimits=(0, 0))
ax.set_ylabel("Frequency")
ax.set_xlabel('Porosity')
fig.tight_layout()
fig.set_size_inches(5, 5)
fig.savefig("porosity.png", dpi=600, transparent=False)
plt.clf()
fig.clf()

# for permeabilty
# back transform from std normal scores to log normal perm values
# Std_dev and permeability taken from Truex et al., (2017) report (PNNL-24709, Rev. 2; RPT-DVZ-AFRI-030, Rev. 2).
stddev_logk = 1.
# must be positive for this calculation and converted to negative after.
logk_avg = 14.1789968165
dflogk = df*stddev_logk+logk_avg
dflogk = np.abs(dflogk)*-1
tdflogk = np.transpose(dflogk)
tdflogk = tdflogk.reshape(1100, 501*8)


fig = plt.figure()
ax = fig.add_subplot(111)
ax.hist(dflogk, bins=np.arange(-18, -10.2, 0.5))
ax.ticklabel_format(style="sci", axis="y", scilimits=(0, 0))
ax.set_ylabel("Frequency")
ax.set_xlabel('Log(k)')
fig.tight_layout()
fig.set_size_inches(5, 5)
fig.savefig("logK.png", dpi=600, transparent=False)
plt.clf()
fig.clf()

np.savetxt("logk_CCUZ_py.txt", dfn)
