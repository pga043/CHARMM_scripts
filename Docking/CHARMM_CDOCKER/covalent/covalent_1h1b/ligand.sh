#!/bin/bash

#sed -i "s/noname/LIG/g" "$dir"/"$lig".mol2
#sed -i '2s/$/LIG/' "$dir"/"$lig".mol2

#export cgenff=/net/orinoco/apps/silcsbio.2022.1/cgenff/cgenff

#$cgenff -v "$dir"/"$lig".mol2 > "$dir"/"$lig".str
sed -n -e '/Toppar/,/END/ p' "$dir"/"$lig".str > "$dir"/"$lig".rtf
sed -n -e '/flex/,/RETURN/ p' "$dir"/"$lig".str > "$dir"/"$lig".prm

obabel -imol2 "$dir"/"$lig".mol2 -opdb > "$dir"/"$lig".pdb

## get the names of carbonyl carbon and oxygen using str file
#export carbon=`grep 'ATOM' "$dir"/"$lig".str | grep 'CG2O1' | awk '{print $2}'`
#export oxygen=`grep "$carbon" "$dir"/"$lig".str | grep 'BOND' | grep -E '(O1|O2|O3|O4|O5)' | awk '{print $3}'`

python ../get_atom_names.py "$lig".mol2

$charmm dir=$dir lig=$lig -i ../build_ligand.inp > $dir/build_ligand.out

## Also in job.sh
##xcen=`cat ../sim-hne/xcen`
##ycen=`cat ../sim-hne/ycen`
##zcen=`cat ../sim-hne/zcen`

$charmm dir=$dir lig=$lig xcen=$xcen ycen=$ycen zcen=$zcen -i ../translate.inp > $dir/translate.out

$charmm dir=$dir lig=$lig -i ../gridcenter.inp > $dir/gridcenter.out
