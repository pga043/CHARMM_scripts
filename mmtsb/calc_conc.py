import math

check_conc = True

if check_conc == True:
    nions = 29
    box = 71.2973465
    #wvol =

    avg = 6.023*10**23 # Avogadro's number
    molecules = nions      # number of molecules in simulation box
    num_moles = nions / avg # number of moles
    size = box # simulation cubic box size, angstroms
    vol = (size * size * size) # angstroms^3

    ## 1 angstroms^3 = 10^-27 liters
    angs_to_lt = vol * 10**-27 # liters

    conc = num_moles / angs_to_lt

    print(f'concentration with box volume: {round(conc, 5)} mol/L')
    print(f'concentration with box volume: {round(conc * 1000, 2)} mmol/L')

    try:
        conc = num_moles / (wvol * 10**-27)
        print(f'concentration with water volume only: {round(conc, 5)} mol/L')
    except NameError: None

    quit()
#=======================================================
'''

print('-'*50)
print('*'*50)
print('-'*50)

# calculate total number of ions required for a specific conc.
avg = 6.023*10**23 # Avogadro's number
conc = 0.15 # mol/L

# charge on protein
charge = 2
box = 67.4743642

# volumes in angstroms**3
# CHARMM>    coor volume space @volspace select .not. segid BWAT end
# CHARMM>    show ?VOLUME
prot_vol =  26638.31

vol = (box * box * box) # angstroms^3
## 1 angstroms^3 = 10^-27 liters
#angs_to_lt = vol * 10**-27 # liters

##==============================================
## following CHARMM script 
wvol = vol - prot_vol  # angstroms**3
wvoll = wvol * 10**-27 # liters
volume = wvoll

if charge > 0:
	total_ions = (conc * volume * avg)
	nions = (conc * volume  * avg) - charge
else:
	total_ions = (conc * volume * avg)
	nions = (conc * volume * avg) + charge

if charge > 0:
	nneg = (nions / 2) + charge
	npos = (nions / 2)
else:
	nneg = (nions / 2)
	npos = (nions / 2) - charge
##==============================================

print(f'cubic box edge = {box} \u212B')
print(f'total number of ions corresponding to a conc of {conc} M are: {round(total_ions)}')
print(f'positive ions = {round(npos)}')
print(f'negative ions = {round(nneg)}')
print(f'total charge on system = {npos + (-nneg) + charge}')
