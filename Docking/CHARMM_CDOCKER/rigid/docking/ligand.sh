#!/bin/bash

#set these variables in job.sh

sed -i "s/UNL/LIG/g" "$dir"/"$lig".mol2
sed -i "s/UNK/LIG/g" "$dir"/"$lig".mol2
#sed -i '2s/$/LIG/' "$dir"/"$lig".mol2

export cgenff=/Data/cbu/cbureuterfs/software/silcsbio.2026.1-alpha/cgenff/cgenff

$cgenff -a -v "$dir"/"$lig".mol2 > "$dir"/"$lig".str
sed -n -e '/Toppar/,/END/ p' "$dir"/"$lig".str > "$dir"/"$lig".rtf
sed -n -e '/flex/,/RETURN/ p' "$dir"/"$lig".str > "$dir"/"$lig".prm

obabel -imol2 "$dir"/"$lig".mol2 -opdb > "$dir"/"$lig".pdb

$charmm dir=$dir lig=$lig -i ../build_ligand.inp > $dir/build_ligand.out

# Also in job.sh
#xcen=`cat ../sim-hne/xcen`
#ycen=`cat ../sim-hne/ycen`
#zcen=`cat ../sim-hne/zcen`

$charmm dir=$dir lig=$lig xcen=$xcen ycen=$ycen zcen=$zcen -i ../translate.inp > $dir/translate.out

$charmm dir=$dir lig=$lig -i ../gridcenter.inp > $dir/gridcenter.out
