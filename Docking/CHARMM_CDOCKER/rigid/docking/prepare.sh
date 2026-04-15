#!/bin/bash

############################################################################################
## This is used to prepare ligand conformers
############################################################################################


############################################################################################
## Generate conformers
############################################################################################

#find these varibales in job.sh
##dir=mol22
##lig=mol22


## Use RDKit to generate conformers
obabel -imol2 "$dir"/"$lig".mol2 -omol > "$dir"/"$lig".mol

echo "check structure and connectivities in mol file"

cp ../conformer.py .
cp ../property.py .
cp ../rename.sh .

python property.py "$dir"/"$lig".mol > tmpresult
free=`awk '{print $1}' tmpresult`
conj=`awk '{print $2}' tmpresult`
numConfs=`sed 1d ../conformer.csv | awk '{if ($2 == free && $3 == conj) print $4}' free=$free conj=$conj`
sed -i'.original' s/changeNum/$numConfs/g conformer.py
python conformer.py "$dir"/"$lig".mol

echo "check whether conformers are generated or not"

## Minimization with CHARMM
rm -rf optimized
mkdir -p optimized
##x_center=`cat ../sim-hne/xcen`
##y_center=`cat ../sim-hne/ycen`
##z_center=`cat ../sim-hne/zcen`

num=`ls conformer/* | wc -l | awk '{print $1}'`
$charmm num=$num xcen=$x_center ycen=$y_center zcen=$z_center dir=$dir lig=$lig < ../mini.inp > output_mini

