#!/bin/bash

dir=chf-6333
lig=chf6333

#sed -i "s/noname/LIG/g" "$dir"/"$lig".mol2
#sed -i '2s/$/LIG/' "$dir"/"$lig".mol2
#cgenff -v "$dir"/"$lig".mol2 > "$dir"/"$lig".str
#sed -n -e '/Toppar/,/END/ p' "$dir"/"$lig".str > "$dir"/"$lig".rtf
#sed -n -e '/flex/,/RETURN/ p' "$dir"/"$lig".str > "$dir"/"$lig".prm

#babel -imol2 "$dir"/"$lig".mol2 -opdb > "$dir"/"$lig".pdb

#$charmm dir=$dir lig=$lig -i build_ligand.inp > $dir/build_ligand.out

#xcen=`cat ../hne/xcen`
#ycen=`cat ../hne/ycen`
#zcen=`cat ../hne/zcen`

#$charmm dir=$dir lig=$lig xcen=$xcen ycen=$ycen zcen=$zcen -i translate.inp > $dir/translate.out

$charmm dir=$dir lig=$lig -i gridcenter.inp > $dir/gridcenter.out
