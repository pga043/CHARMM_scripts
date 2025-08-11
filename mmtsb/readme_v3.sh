#!/bin/bash

charmm=/Data/cbu/cbureuterfs/pga043/charmm/49a1_blade/charmm/build_charmm/charmm

#cat ../chaina_charmm.pdb ../core.pdb ../site*.pdb ../wata_charmm.pdb ../iona_charmm.pdb > complex.pdb
## remove END after protein in complex.pdb
#sed -i "s/ENDATOM/ATOM/g"  complex.pdb
#sed -i '/TER/d' complex.pdb
#exit 0
## charge on 8QER dimer = -16 and -4 ions 
## charge on 8QER monomer = -8 and -2

#convpdb.pl -solvate -cutoff 10 -cubic -out charmm22 -segnames complex.pdb > solvated.pdb 2> hydration.log
#export XYZ=`awk 'BEGIN {CC=0} {if ($1=="ATOM" && $2==1) {if (CC==0) {CC=1; X=$6; Y=$7; Z=$8} else {print X-$6,Y-$7,Z-$8}}}' ../chaina_charmm.pdb solvated.pdb`
#echo $XYZ
#convpdb.pl -translate $XYZ -segnames solvated.pdb > translated.pdb

### extract only the newly added water molecules (except crystal waters)
#cw=`grep -n 'CLA' solvated.pdb | tail -1 | cut -d: -f1` #or use WT00 or something that was in the end.
#sed "1,${cw}d" translated.pdb > solvent_segs.pdb

###awk '/WT00/ {found=1; next} found' solvated.pdb  > solvent_tmp.pdb
###convpdb.pl -translate $XYZ -segnames solvent_tmp.pdb > solvent_translated.pdb 
###convpdb.pl -segnames -nsel TIP3 solvent_translated.pdb > solvent_segs.pdb 

#while read seg
#do
#new_seg="${seg,,}"
#echo $seg
#( grep "$seg" solvent_segs.pdb; echo "END" ) > solvent_"$new_seg".pdb
#done < <(awk '{print $NF}'  solvent_segs.pdb | head -n -2 | sort -u)

export n=`awk '{print $NF}'  solvent_segs.pdb | head -n -2 | sort -u | wc -l`
#$charmm prot=../chaina n=$n -i get_ions.inp

#convpdb.pl -ions POT:`grep -i pot sys_info.str  | awk '{print $NF}'`=CLA:`grep -i cla sys_info.str  | awk '{print $NF}'` translated.pdb > neutralized.pdb

#grep -i HETATM neutralized.pdb | sed "s/HETATM/ATOM  /g" > ions_tmp.pdb
#convpdb.pl -segnames -nsel POT ions_tmp.pdb -setseg POS > pot.pdb
#convpdb.pl -segnames -nsel CLA ions_tmp.pdb -setseg NEG > cla.pdb

$charmm n=$n -i build.inp

## if satisfied =>
#rm solvent_tmp.pdb solvent_segs.pdb solvent_wt*.pdb ions_tmp.pdb
