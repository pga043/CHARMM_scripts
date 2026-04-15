#!/bin/bash

for i in bg*
do
echo "$i"

# change for ligand
export mol=bg
export lig="$i"

cd "$lig"

rm -rf pdbs *.bin output_* cluster.log *.py tmp* 


cd ../

done



