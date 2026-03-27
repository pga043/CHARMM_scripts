import sys, os
import numpy as np
import pycharmm
import pycharmm.psf as psf
import pycharmm.read as read
import pycharmm.write as write
import pycharmm.settings as settings
import pycharmm.atom_info as atom_info
import pycharmm.scalar as scalar

'''
Function from: Charles L. Brooks III
December 9, 2024
'''

def hmr(oldpsf='', newpsf=''):
    # HMR revisited
    # Get all the masses from the current atoms
    masses = np.array(psf.get_amass())
    resnames = np.array(atom_info.get_res_names(np.arange(0,psf.get_natom(),1)))
    # Build a logical array of all the atoms which are not 'TIP3' waters
    not_waters = resnames != 'TIP3'
    # Build a logical array of all hydrogen atoms based on criterion m_H <= 2
    hydrogens = masses <= 2
    # Build a logical array of all hydrogen atoms not belonging to 'TIP3' waters
    not_water_hydrogen = hydrogens*not_waters
    # Augment each non-water hydrogen mass by 2x original hydrogen mass
    masses += 2*masses*not_water_hydrogen
    # Process the bond array to find heavy atom - hydrogen bonds, 
    # reduce mass of heavy atom by 2*m_H
    bonds = np.array(psf.get_ib_jb())
    for ibnd in range(bonds.shape[1]):
        ib = bonds[0,ibnd]-1
        jb = bonds[1,ibnd]-1
        if not_water_hydrogen[ib] or not_water_hydrogen[jb]:
            if not_water_hydrogen[ib]: masses[jb] -= 2.016
            else: masses[ib] -= 2.016
    # Reset masses to new values
    scalar.set_masses(masses)
    # Write the new psf if requested
    #if newpsf != '': write.psf_card(f'{newpsf}_hmr')
    write.psf_card(newpsf)

#=======================================================
dir = 'EOS14090'
DIR = 'EOS14090'
prot = 'DIMER'
lig = 'EOS14090'
LIG = 'EOS14090'

psf1 = '"EOS14090/DIMER-EOS14090-neutralized.psf"' 
psf2 = '"EOS14090/DIMER-EOS14090-neutralized_hmr.psf"'

## read topology and paramter files
#read.stream(f'toppar.str')
read.rtf('toppar/top_opls_aam.inp')
read.prm('toppar/par_opls_aam.inp', flex=True)

read.rtf('"EOS14090/EOS14090_charmm.rtf"', append=True)
read.prm('"EOS14090/EOS14090_charmm.prm"', flex=True, append=True)


old = read.psf_card(psf1)
hmr(oldpsf=old, newpsf=psf2)
