import os, sys
import numpy as np

'''
Parveen Gartan, Mahmoud Moqadam
6 February 2024
Usage of this script by anyone requires permission from the authors above.
'''

ER = {'POPC': 67, 'POPE': 30, 'POPI': 13, 'POPS': 7, 'CHL1': 6, 'CER180': 5}
GOLGI = {}


memb = globals()[sys.argv[1]]

##------------------------------------------------
try:
   os.remove('nlipids_lower.prm')
   os.remove('nlipids_upper.prm')
except FileNotFoundError:
    print('Membrane composition file does not exists.')

#=================================================
nlipids = sum(memb.values())
print(f'number of lipids in each leaflet = {nlipids}')

if nlipids > 128:
    print('The number of lipids in user defined bilayer exceeds 128 per leaflet.')
    print('ABNORMAL TERMINATION OF CHARMM expected.')
    quit()
else:
    None


##==================================================
ref = np.genfromtxt('/net/orinoco/pga043/lipids/streams/lower.prm', dtype=str, usecols=1)
#for lipid in range(len(ref)):
#    print(ref[lipid][1:])

##==================================================
lipids = []
with open('nlipids_lower.prm', 'a') as f1, open('nlipids_upper.prm', 'a') as f2:
    for key, value in memb.items():
        f1.write(f'set n{key.lower()}bot = {value} \n')
        f2.write(f'set n{key.lower()}top = {value} \n')
        lipids.append(f'{key.lower()}')

    for lipid in range(len(ref)):
        if ref[lipid][1:] not in lipids:            
            f1.write(f'set {ref[lipid]}bot = 0 \n')
            f2.write(f'set {ref[lipid]}top = 0 \n')


quit()

