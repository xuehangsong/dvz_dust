import numpy as np
import os
import matplotlib.pyplot as plt
import csv

"""
this script is for reproduce results of the R scripts NandK_trans.R
09/26/2018
"""

os.chdir("/people/song884/dust/fy18/NQAP/")

# read n,k data for ccuz
n = np.loadtxt('ns.txt')
k = np.loadtxt('ks.txt')
k = (10 ** k)*997.*9.8/0.00089
k = k*100.

# read units properties
properties = dict()
with open("s7_mat.txt") as csvfile:
    reader = csv.reader(csvfile, delimiter=",")
    row = next(reader)
    nx, ny, nz = [int(row[i]) for i in range(3)]
    row = next(reader)
    n_unit = int(row[0])
    for irow in range(n_unit):
        row = next(reader)
        properties[row[0]] = dict()
        properties[row[0]]["iz"] = np.arange(int(row[5])-1, int(row[6]), 1)
    for irow in range(n_unit):
        row = next(reader)
        properties[row[0]]["n"] = float(row[3])
    for irow in range(n_unit):
        row = next(reader)
        properties[row[0]]["k"] = float(row[1])
    for irow in range(n_unit):
        row = next(reader)
        properties[row[0]]["sat1"] = float(row[2])
        properties[row[0]]["sat2"] = float(row[4])
        properties[row[0]]["sat3"] = float(row[5])

# initialize arrays
ijk_n = np.zeros(nx*ny*nz)
ijk_k = np.zeros(nx*ny*nz)
ijk_sat1 = np.zeros(nx*ny*nz)
ijk_sat2 = np.zeros(nx*ny*nz)
ijk_sat3 = np.zeros(nx*ny*nz)

for i_unit in properties.keys():
    print(i_unit)
    cell_index = np.arange(min(properties[i_unit]["iz"]*nx*ny),
                           max(properties[i_unit]["iz"]+1)*nx*ny)

    ijk_sat1[cell_index] = properties[i_unit]["sat1"]
    ijk_sat2[cell_index] = properties[i_unit]["sat2"]
    ijk_sat3[cell_index] = properties[i_unit]["sat3"]

    if i_unit == "CCUz":
        ijk_n[cell_index] = n
        ijk_k[cell_index] = k
    else:
        ijk_n[cell_index] = properties[i_unit]["n"]
        ijk_k[cell_index] = properties[i_unit]["k"]


np.savetxt("ijk_n_py.txt", ijk_n)
np.savetxt("ijk_k_py.txt", ijk_k)
np.savetxt("ijk_sat1_py.txt", ijk_sat1)
np.savetxt("ijk_sat2_py.txt", ijk_sat2)
np.savetxt("ijk_sat3_py.txt", ijk_sat3)
