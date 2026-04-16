#!/bin/bash

############################################################################################
## This is used to prepare ligand conformers
############################################################################################


############################################################################################
## Generate conformers
############################################################################################

dir=chf-6333
lig=chf6333

## Use RDKit to generate conformers
#babel -ipdb "$dir"/"$lig".pdb -omol -x3 "$dir"/"$lig".mol
#python property.py | sed s/"("//g | sed s/")"//g | sed s/","//g > tmpresult
#total=`awk '{print $1}' tmpresult`
#numConfs=`sed 1d conformer.csv | awk '{if ($2 == total) print $5}' total=$total` 
#sed -i'.original' s/changeNum/$numConfs/g conformer.py
#python conformer.py

## Minimization with CHARMM
rm -rf optimized
mkdir -p optimized
x_center=`cat ../hne/xcen`
y_center=`cat ../hne/ycen`
z_center=`cat ../hne/zcen`
num=`ls conformer/* | wc -l | awk '{print $1}'`
$charmm num=$num xcen=$x_center ycen=$y_center zcen=$z_center dir=$dir lig=$lig < mini.inp > output_mini

