#!/bin/bash

#cat ../prep/hne_charmm.pdb ../prep/core.pdb ../prep/site*.pdb > complex.pdb
## remove END after protein in complex.pdb
#sed -i "s/ENDATOM/ATOM/g"  complex.pdb
#sed -i '/TER/d' complex.pdb

## charge on HNE = +11 (counter ions: 18 CL, 7 POT)
## charge on PR3 = +2

#convpdb.pl -solvate -cutoff 10 -cubic -ions CLA:18 -ions SOD:7 -out charmm22 complex.pdb > neutr-solv.pdb

##read 648 atoms, 216 residues from /Home/ii/parveeng/Softwares/toolset/data/water.pdb
##read 3437 atoms, 219 residues from -
##box size: 73.926518 x 73.926518 x 73.926518


#convpdb.pl -segnames -nsel TIP3 neutr-solv.pdb > solvent.pdb
#convpdb.pl -segnames -nsel CLA neutr-solv.pdb > ions.pdb
#convpdb.pl -segnames -nsel SOD neutr-solv.pdb >> ions.pdb


#sed -i "s/HETATM/ATOM  /g" ions.pdb

#grep 'WT01' solvent.pdb > solvent01.pdb # apend END in last line
#grep 'WT00' solvent.pdb > solvent00.pdb # apend END in last line


#---------------------------------------------------------------------
## TEST

# HSD41 : ND1 = coordintes from complex.pdb and neutr-solvated.pdb
# HSD41: ND1 = complex coordinates - neutr-solvated coorintes
# convpdb.pl -translate 16.938 -27.032 0.406 neutr-solv.pdb > test1.pdb

#Calculate the RMSD difference without alignment between PROT from complex.pdb and test1.pdb

# It turn out that MMTSB only does translation when solvating the system.
