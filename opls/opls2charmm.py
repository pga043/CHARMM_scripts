import os, sys, subprocess
import networkx as nx

'''
Parveen Gartan
12 Feb 2024
'''

rtf = open(f'{sys.argv[1]}.opls.rtf', 'r')
prm1 = open(f'{sys.argv[1]}.opls.prm', 'r')

'''
version1:
## opls protein FF file has C1**, C2**, C3**, C5**, N2**, N3**, N5**, O1**, O2**, S2**
## new atom types will start with "_" e.g. C_**, N_** etc. (I don't know if it's the best solution yet.)
#nn = "_"

version2:
added _ in front of ligpargen atom types: _C800, _N810 etc.
'''

resid = 'xray'

MASS   = []
RESI  = []
ATOMS = []
BONDS = []
IMPR  = []
AT = []
NAT = []

try:
   os.remove(f'{sys.argv[1]}_charmm.rtf')
   os.remove(f'{sys.argv[1]}_charmm.prm')
except FileNotFoundError:
    print('File does not exists.')


out_rtf = open(f'tmp.rtf', 'a') 
out_prm = open(f'{sys.argv[1]}_charmm.prm', 'a')


#---------------- rtf ---------------------------
out_rtf.write('!CHARMM rtf file generated by LigParGen program (israel.cabezadevaca@yale.edu) \n')
out_rtf.write('* \n')
out_rtf.write('  36 1 \n')

for line in rtf:
    if line.startswith('MASS'):
        x = line.split()
        AT.append(f'{x[2]}')
        nat = f'_{x[2]}'
        #''.join([string.replace("8", nn) for string in x[2]]) ## opls atom-types from ligpargen starts with number 8
        out = f'{x[0]} -1 {nat} {x[3]}'
        #out_rtf.write(f'{out} \n')
        MASS.append(out)
    elif line.startswith('RESI'):
        y = line.split()
        out = f'{y[0]} {resid} {y[-1]}'
        RESI.append(out)
    elif line.startswith('ATOM'):
        a = line.split()
        nat = f'_{a[2]}'   #''.join([string.replace("8", nn) for string in a[2]])
        a = f'{a[0]} {a[1]}   {nat}  {a[3]}'
        ATOMS.append(a)
    elif line.startswith('BOND'):
        BONDS.append(line)
    elif line.startswith('IMPR'):
        IMPR.append(line)         


#NAT = [string.replace("8", nn) for string in AT]
NAT = [f"_{s}" for s in AT]
print(f'Old atom types = {AT}')
print(f'New atom types = {NAT}')

for mass in MASS:
    out_rtf.write(f'{mass} \n')

out_rtf.write('AUTO ANGLES DIHE \n')
out_rtf.write(f'\n')

for resi in RESI:
    out_rtf.write(f'{resi} \n')  ## max 3 characters
for atom in ATOMS:
    out_rtf.write(f'{atom} \n')
for bond in BONDS:
    out_rtf.write(f'{bond}')
for impr in IMPR:
    out_rtf.write(f'{impr}')

out_rtf.write('PATCH FIRST NONE LAST NONE \n')

out_rtf.write('END \n')
out_rtf.write(f'\n')

#-------------------------------------------------------
#--------------- PRM -----------------------------------
out_prm.write('!--------------------------------------------- \n')
out_prm.write('!        Generated with LigParGen \n')
out_prm.write('!        William L. Jorgensen Lab \n')
out_prm.write('!     Author: israel.cabezadevaca@yale.edu \n')
out_prm.write('!    OPLS Force Field with CM1A derived Atomic Charges \n')
out_prm.write('!--------------------------------------------- \n')

out_prm.write('ATOM \n')
for mass in MASS:
    out_prm.write(f'{mass} \n')

out_prm.write(f'\n')

BONDS    = []
ANGLES   = []
DIHE     = []
IMPR     = []
NONBOND  = []

prm = [prm1]

for f in range(len(prm)):
    for line in prm[f]:
        if line[0:4] == 'BOND':
           for line in prm[f]:
               if line[0:5] == 'ANGLE':
                  break
               elif len(line.strip()) == 0 :
                  break
               x = line.split()
               at1 = NAT[AT.index(x[0])]
               at2 = NAT[AT.index(x[1])]
               #print(at1, at2)  
               out = f'{at1} {at2} {x[2]} {x[3]}'
               BONDS.append(out)
        elif line[0:5] == 'ANGLE':
             for line in prm[f]:
                 if line[0:8] == 'DIHEDRAL':
                    break
                 elif len(line.strip()) == 0 :
                    break
                 y = line.split()
                 at1 = NAT[AT.index(y[0])]
                 at2 = NAT[AT.index(y[1])]
                 at3 = NAT[AT.index(y[2])]
                 y = f'{at1} {at2} {at3} {y[3]} {y[4]}'
                 ANGLES.append(y)
        elif line[0:8] == 'DIHEDRAL':
             for line in prm[f]:
                 if line[0:8] == 'IMPROPER':
                    break
                 elif len(line.strip()) == 0 :
                     break
                 elif line[0] == '!':
                     break
                 z = line.split()
                 at1 = NAT[AT.index(z[0])]
                 at2 = NAT[AT.index(z[1])]
                 at3 = NAT[AT.index(z[2])]
                 at4 = NAT[AT.index(z[3])]
                 z = f'{at1} {at2} {at3} {at4} {z[4]} {z[5]} {z[6]}'
                 DIHE.append(z)

        elif line[0:8] == 'IMPROPER':
             for line in prm[f]:
                 if line[0:9] == 'NONBONDED':
                    break
                 elif len(line.strip()) == 0 :
                    break
                 elif line[0] == '!':
                    break
                 m = line.split()
                 at1 = NAT[AT.index(m[0])]
                 at2 = NAT[AT.index(m[1])]
                 at3 = NAT[AT.index(m[2])]
                 at4 = NAT[AT.index(m[3])]
                 #print(f'{m} ! {prm[f].name}\n')
                 m = f'{at1} {at2} {at3} {at4} {m[4]} {m[5]} {m[6]}'
                 IMPR.append(m)
        elif line[0:5] == 'cutnb':
             for line in prm[f]: 
                if len(line.strip()) == 0 :
                   break
                elif line[0:3] == 'END':
                    break
                n = line.split()
                at1 = NAT[AT.index(n[0])]
                n = f'{at1} {n[1]} {n[2]} {n[3]} {n[4]} {n[5]} {n[6]}'
                NONBOND.append(n)

##------------------------------------------

out_prm.write('BOND \n')
for bond in BONDS:
    out_prm.write(f'{bond} \n')
out_prm.write(f'\n')

out_prm.write('ANGLE \n')
for angle in ANGLES:
    out_prm.write(f'{angle} \n')
out_prm.write(f'\n')

out_prm.write('DIHEDRAL \n')
for dihe in DIHE:
    out_prm.write(f'{dihe} \n')
out_prm.write(f'\n')

out_prm.write('IMPROPER \n')
for impr in IMPR:
    out_prm.write(f'{impr} \n')
out_prm.write(f'\n')

out_prm.write(f'NONBONDED nbxmod 5 atom cdiel switch vatom vdistance vswitch - \n')
out_prm.write(f'cutnb 14.0 ctofnb 12.0 ctonnb 11.5 eps 1.0 e14fac 0.5  geom \n')

for nonb in NONBOND:
    out_prm.write(f'{nonb} \n')
out_prm.write(f'\n')
out_prm.write(f'END \n')


#quit()

##-------- CHARMM duplicate parameters check--------
#out_rtf.close()
#out_prm.close()

#charmmrun = f'/net/orinoco/pga043/charmm_nonstd/new_charmm/build_blade/charmm -i test.inp'
#subprocess.check_call(charmmrun, shell=True)

#quit()
#----------------------------------------------------

#-----------------------------------------------
#------------ add group definitions ------------
out_rtf.close()

os.system(f'./regroup.awk tmp.rtf > {sys.argv[1]}_charmm.rtf ')

try:
    os.remove('tmp.rtf')
except FileNotFoundError:
     print('No junk files exist.')

quit()
