#!/bin/bash

charmm=/Data/cbu/cbureuterfs/pga043/charmm/49a1_blade/charmm/build_charmm/charmm

#cat ../8qer_dimer.pdb ../core.pdb ../site*.pdb > complex.pdb
## remove END after protein in complex.pdb
#sed -i "s/ENDATOM/ATOM/g"  complex.pdb
#sed -i '/TER/d' complex.pdb

## charge on 8QER = -20 

#convpdb.pl -solvate -cutoff 10 -cubic -out charmm22 complex.pdb > solvated.pdb
##box size: 118.591086 x 118.591086 x 118.591086

#awk '/LIG/ {found=1; next} found' solvated.pdb  > solvent_tmp.pdb
#convpdb.pl -segnames -nsel TIP3 solvent_tmp.pdb > solvent_segs.pdb 

#while read seg
#do
#new_seg="${seg,,}"
#echo $seg
#( grep "$seg" solvent_segs.pdb; echo "END" ) > solvent_"$new_seg".pdb
#done < <(awk '{print $NF}'  solvent_segs.pdb | head -n -2 | sort -u)

export n=`awk '{print $NF}'  solvent_segs.pdb | head -n -2 | sort -u | wc -l`
#$charmm prot=../8qer_dimer n=$n -i get_ions.inp

#convpdb.pl -ions POT:`grep -i pot sys_info.str  | awk '{print $NF}'`=CLA:`grep -i cla sys_info.str  | awk '{print $NF}'` solvated.pdb > neutralized.pdb

#grep -i HETATM neutralized.pdb | sed "s/HETATM/ATOM  /g" > ions_tmp.pdb
#convpdb.pl -segnames -nsel POT ions_tmp.pdb -setseg POS > pot.pdb
#convpdb.pl -segnames -nsel CLA ions_tmp.pdb -setseg NEG > cla.pdb

$charmm n=$n -i build.inp
#rm solvent_tmp.pdb solvent_segs.pdb solvent_wt*.pdb
#---------------------------------------------------------------------
## TEST

# HSD41 : ND1 = coordintes from complex.pdb and neutr-solvated.pdb
# HSD41: ND1 = complex coordinates - neutr-solvated coorintes
# convpdb.pl -translate 16.938 -27.032 0.406 neutr-solv.pdb > test1.pdb

#Calculate the RMSD difference without alignment between PROT from complex.pdb and test1.pdb

# It turn out that MMTSB only does translation when solvating the system.
