#!/bin/bash

for i in 72 105
#while read i
do
echo "$i"

# change for ligand
export mol=bg
export lig="$mol""$i"

cd "$lig"

rm -rf pdbs *.bin output_* cluster.log *.py tmp* 


cd ../

done
#done < <(sed '1,7d' /net/orinoco/pga043/AnnArbor/forPR3_NE_paper/dimethyl.txt | awk '{print $1}')

#done < <(sed '1,7d' /net/orinoco/pga043/AnnArbor/forPR3_NE_paper/piperidine.txt | awk '{print $1}')


