import sys, os, psutil
import MDAnalysis as mda
from MDAnalysis.analysis import rms, align
# import nglview as nv
import matplotlib.pyplot as plt
import numpy as np
import warnings
# suppress some MDAnalysis warnings about writing PDB files
warnings.filterwarnings('ignore')


##----------------------
if len(sys.argv) !=3:
   print('Three command line options are required.')
   print('Usage: python rmsf.py psf_file dcd_file')
   print('Exiting...')
   quit()
##-----------------------

traj_size = round(os.path.getsize(sys.argv[2])*10**-9, 2) ## GB
availabe_ram = psutil.virtual_memory()[1]/1000000000
print(f'dcd size (GB): {traj_size}, available RAM (GB): {availabe_ram}')

if traj_size < availabe_ram:
   in_memory = True
else:
   in_memory = False

#------------------------------------------

# Replace with paths to your own trajectory and topology files
u = mda.Universe(sys.argv[1], sys.argv[2], in_memory=in_memory)

n_resi = u.select_atoms('protein or segid PROT').residues.n_residues

## Creating an average structure
average = align.AverageStructure(u, u, select='protein and name CA',
                                 ref_frame=0).run()
ref = average.results.universe

## Aligning the trajectory to a reference
if in_memory == True:
   print(f'traj loaded in memory')
   aligner = align.AlignTraj(u, ref,
                             select='protein and name CA',
                             in_memory=True).run()
else:
    # if can't load traj in memory
    aligner = align.AlignTraj(u, ref,
                              select='protein and name CA',
                              filename='aligned_traj.dcd',
                               in_memory=False).run()
    u = mda.Universe(sys.argv[1], 'aligned_traj.dcd')

## Calculating RMSF
c_alphas = u.select_atoms('protein and name CA')
R = rms.RMSF(c_alphas).run()

## Plotting RMSF
plt.plot(c_alphas.resids, R.results.rmsf)
plt.xlabel('Residue number', fontsize=18)
plt.ylabel('RMSF ($\AA$)', fontsize=18)

# changing the fontsize of ticks
plt.xticks(fontsize=16, rotation=0)
plt.yticks(fontsize=16)

# specifying horizontal line type 
plt.axhline(y = 1, color = 'r', linestyle = '-') 

#plt.xticks(np.arange(0, n_resi, 20))
#plt.axvspan(122, 159, zorder=0, alpha=0.2, color='orange', label='LID')
#plt.axvspan(30, 59, zorder=0, alpha=0.2, color='green', label='NMP')

plt.legend()
plt.show()

quit()



