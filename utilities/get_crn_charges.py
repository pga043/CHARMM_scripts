import sys, os

nsubs = 2
dir_name = 'build.fep'

#-----------------------------------------------------------
def read_crn_rtf(filename):
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
#-----------------------------------------------------------
core = read_crn_rtf(f'{dir_name}/core.rtf')
s1s1 = read_crn_rtf(f'{dir_name}/site1_sub1_pres.rtf')
s1s2 = read_crn_rtf(f'{dir_name}/site1_sub2_pres.rtf')

try:
    os.remove(f's1s1_ff2crn_qpert.str')
    os.remove(f's1s2_ff2crn_qpert.str')
except FileNotFoundError:
    print('Files do not exists.')

sub1_str = open(f's1s1_ff2crn_qpert.str', 'a')
sub1_str.write(f'* Change atom charges to renormalized charges for ligand s1s1 \n')
sub1_str.write(f'* \n')
sub1_str.write(f'\n')

for an, q in zip(core['an'], core['q']):
	#if an[:2] != "LP": # remove this line after initial testing
	sub1_str.write(f"scalar charge set {q} sele atom LIG 1 {an} end \n")

for an, q in zip(s1s1['an'], s1s1['q']):
    sub1_str.write(f"scalar charge set {q} sele atom LIG 1 {an} end \n")

sub1_str.write(f' \n')
sub1_str.write('RETURN')

#===================================================================#
#===================================================================#
sub2_str = open(f's1s2_ff2crn_qpert.str', 'a')
sub2_str.write(f'* Change atom charges to renormalized charges for ligand s1s2 \n')
sub2_str.write(f'* \n')
sub2_str.write(f'\n')

for an, q in zip(core['an'], core['q']):
	#if an[:2] != "LP": # remove this line after initial testing
	sub2_str.write(f"scalar charge set {q} sele atom LIG 1 {an} end \n")

for an, q in zip(s1s2['an'], s1s2['q']):
    sub2_str.write(f"scalar charge set {q} sele atom LIG 1 {an} end \n")

sub2_str.write(f' \n')
sub2_str.write('RETURN')

quit()
