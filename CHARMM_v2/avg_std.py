import math
import sys
import numpy as np

# run==> python avg_std.py file.dat

#inter_1-2.dat format:  TIME PROT_S1-LIGAND PROT-S2-LIGAND
# change skip_header accordingly (0 = no header, 1 = 1st line is a header, ...)

series = np.genfromtxt(sys.argv[1], dtype=None, skip_header=1, delimiter=' ', names=['X','Y','Z'])

s1_ligand = series['Y']
s2_ligand = series['Z']

print("S1_ligand average:" + ' ' +str(np.average(s1_ligand)))
print("S1_ligand standard deviation:" + ' ' +str(np.std(s1_ligand)))

print("S2_ligand average:" + ' ' +str(np.average(s2_ligand)))
print("S2_ligand standard deviation:" + ' ' +str(np.std(s2_ligand)))


