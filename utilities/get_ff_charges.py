import sys, os
import numpy as np

translation = 'translation.txt'
mcs         = 'MCS_for_MSLD.txt'
rtfs        = np.genfromtxt('mol_list.txt', dtype=str)

# Function to read FF RTF file
def read_ff_rtf(filename):
    ff = {'an': [], 'at': [], 'q': [], 'bond': []}
    with open(filename, 'r') as f:
        for line in f:
            tokens = line.split()
            if not tokens:
                continue
            if tokens[0] == 'ATOM':
                ff['an'].append(tokens[1])
                ff['at'].append(tokens[2])
                ff['q'].append(float(tokens[3]))
            elif tokens[0] == 'BOND':
                ff['bond'].append((tokens[1], tokens[2]))
    #print(ff)
    return ff

#-----------------------------------------------------------------------
with open(mcs, 'r') as f1:
    for lines in f1:
        line = lines.strip()
        if line.startswith("REFLIG"):
            line = lines.split()
            rtf1 = line[-1]

rtf2 = [x for x in rtfs if x != rtf1][0]

mcs_translation = {'sub1': [], 'sub2': [], 'sub1_new': [], 'sub2_new':[]}
core_lines = False

with open(mcs, 'r') as f:
	for lines in f:
		try:
			line = lines.split()
			if line[0] == rtf1:
				for atom in line[1:]:
					if atom != 'DUM':
						mcs_translation['sub1'].append(atom)
			if line[0] == rtf2:
				for atom in line[1:]:
					if atom != 'DUM':
						mcs_translation['sub2'].append(atom)
		except IndexError: pass

#-----------------------------------------------------------------------

tag = None
with open(translation, 'r') as f:
    for lines in f:
        line = lines.strip()
        if not line or line.startswith("Original"):
            continue

        if line == 'CORE':
            tag = 'core'
            continue
        if line.startswith("SITE 1 site1_sub1"):
            tag = 'sub1'
            continue
        if line.startswith("SITE 1 site1_sub2"):
            tag = 'sub2'
            continue

        line = lines.split()
        if tag == 'core':
            #if line[0][:2] != "LP": #skip lone pairs, delete it later
            mcs_translation['sub1_new'].append(line[-1])
            mcs_translation['sub2_new'].append(line[-1])
        if tag == 'sub1':
            mcs_translation['sub1_new'].append(line[-1])
        if tag == 'sub2':
            mcs_translation['sub2_new'].append(line[-1])
#-----------------------------------------------------------------------
try:
	os.remove(f's1s1_crn2ff_qpert.str')
	os.remove(f's1s2_crn2ff_qpert.str')
except FileNotFoundError:
	print('Files do not exists.')


ff = read_ff_rtf(f'{rtf1}.rtf')
#print(ff)

sub1_str = open(f's1s1_crn2ff_qpert.str', 'a')
sub1_str.write(f'* Change atom charges to original charges for ligand s1s1 \n')
sub1_str.write(f'* \n')
sub1_str.write(f'\n')

for an, new in zip(mcs_translation['sub1'], mcs_translation['sub1_new']):
	if an in ff['an']:
		idx = ff['an'].index(an)
		#print(an, new, ff['q'][idx])
		sub1_str.write(f"scalar charge set {ff['q'][idx]} sele atom LIG 1 {new} end \n")

sub1_str.write(f' \n')
sub1_str.write('RETURN')

#=========================================================================================
#=========================================================================================
ff = read_ff_rtf(f'{rtf2}.rtf')
#print(ff)
    
sub2_str = open(f's1s2_crn2ff_qpert.str', 'a')
sub2_str.write(f'* Change atom charges to original charges for ligand s1s2 \n')
sub2_str.write(f'* \n')
sub2_str.write(f'\n')

for an, new in zip(mcs_translation['sub2'], mcs_translation['sub2_new']):
    if an in ff['an']:
        idx = ff['an'].index(an)
        #print(an, new, ff['q'][idx])
        sub2_str.write(f"scalar charge set {ff['q'][idx]} sele atom LIG 1 {new} end \n")

sub2_str.write(f' \n')
sub2_str.write('RETURN')

quit()



#for at1, at2 in zip(mcs_translation['sub1'], mcs_translation['sub1_new']):
#	print(at1, at2)

#print(mcs_translation['sub1'], mcs_translation['sub1_new'])
#print(len(mcs_translation['sub1']), len(mcs_translation['sub1_new']))
quit()	
