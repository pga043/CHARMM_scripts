import matplotlib.pyplot as plt
import numpy as np
import math
import seaborn as sns
import os
#from collections import defaultdict

print('Q-RMSD cutoff (JCIM article): 0.001 e-')
print(u'log\u2081\u2080''(Q-RMSD) cutoff > -3.0')
print('==========================================')

dim1 = 1
dim2 = 2
total_plots = dim1*dim2
fig, axs = plt.subplots(dim1, dim2)
#fig.set_size_inches(20, 10)
fig.dpi = 200

nsubs=2

# Make a plot for each ligand
for mol,ax in enumerate(axs.reshape(-1)):
    molid = mol+1

    ff = {}
    crn = {}

    # Retrieve charge sets
    ff_str = np.genfromtxt('s1s' + str(molid) + '_crn2ff_qpert.str' , dtype=str, skip_header=3, skip_footer=1)
    #ff = np.array(ff_str[:, 3], dtype=float)
    ff = {x: float(y) for x, y in zip(ff_str[:, -2], ff_str[:, 3])}
    #print(ff_str)

    crn_str = np.genfromtxt('s1s' + str(molid) + '_ff2crn_qpert.str', dtype=str, skip_header=3, skip_footer=1)
    crn = {x: float(y) for x, y in zip(crn_str[:, -2], crn_str[:, 3])}
    #print(crn_str)

    # align the atom names and charges in the two dictionaries
#----------------------------------------------------------------------#
	# Source - https://stackoverflow.com/a/5946322
	# Posted by Eli Bendersky, modified by community. See post 'Timeline' for change history
	# Retrieved 2026-02-17, License - CC BY-SA 4.0
    #ff_crn = defaultdict(list)
    
    #for d in (ff, crn):
    #    for key, value in d.items():
    #        ff_crn[key].append(value)

# Source - https://stackoverflow.com/a/5946463
    ff_crn = {}

    for key in set(list(ff.keys()) + list(crn.keys())):
        try:
           ff_crn.setdefault(key,[]).append(ff[key])        
        except KeyError:
           pass

        try:
           ff_crn.setdefault(key,[]).append(crn[key])          
        except KeyError:
           pass

    #print(ff_crn)
#----------------------------------------------------------------------#
    #for key, value in ff_crn.items():
    #    print(key, value)    
	
    # Paste the two columns side by side
    array = np.array(list(ff_crn.values()))

    ff = array[:, 0]
    crn = array[:, -1]
    an = list(ff_crn.keys())

    # Calculate the RMSD
    rmsd = np.sqrt(np.mean((crn - ff) ** 2))
    log10 = math.log10(rmsd)

    print("Q rmsd:", "%.4f" % rmsd)
    print(u'log\u2081\u2080'"(Q rmsd (ff-crn)):", "%.4f" % log10)

    # Plot them
    ax.scatter(ff,crn,marker='o',linewidth=0.5, label='')

    # Add labels above each marker
    for i, name in enumerate(an):
        ax.text(ff[i], crn[i] + 0.01, name, ha='center', va='bottom', fontsize=5)
    
    # Plot y=x line
    ax.axline((0, 0), slope=1)
    
    # Axis specs:
    ## Title
    ax.set_title(f'$L_{molid}$ - QRMSD={rmsd:.4f}',fontsize=10)
    
    ## Scale
    #ax.set_xlim(-0.9,0.7)
    #ax.set_ylim(-0.9,0.7)
    
    ## Labels
    if mol%dim2 == 0:
       ax.set_ylabel('Renormalized charges',fontsize=10)
    if mol > total_plots-dim2-1:
       ax.set_xlabel('FF charges',fontsize=10)

    else:
        molid += 1

plt.tight_layout()
plt.show()
quit()
