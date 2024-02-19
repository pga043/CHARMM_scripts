import MDAnalysis as mda
import pandas as pd
import matplotlib.pyplot as plt
import sys, os
from MDAnalysis.analysis import rms

u = mda.Universe(sys.argv[1], sys.argv[2], in_memory=True)
protein = u.select_atoms("protein")

for segids in range(len(u.segments.segids)):
    segid = u.segments.segids[segids]
    if segid == 'XRAY' or segid == 'REVR':
        LIG = f'resname {segid}'

print(LIG)

R = rms.RMSD(u,  # universe to align
             u,  # reference universe or atomgroup
             select='backbone',  # group to superimpose and calculate RMSD
             groupselections=[LIG],  # groups for RMSD
             ref_frame=0)  # frame index of the reference
R.run()

df = pd.DataFrame(R.results.rmsd, columns=['Frame', 'Time (ns)', 'Backbone', 'LIG'])

ax = df.plot(x='Frame', y=['Backbone', 'LIG'], kind='line')
ax.set_ylabel('RMSD (Angstrom)')

plt.show()

quit()
