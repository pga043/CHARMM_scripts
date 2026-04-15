#!/bin/bash

#ml load anaconda/2021
#conda activate pgartan


END=144
for((i=1;i<=END;i++))
do
if [ ! -f ../../../Bergen/bg$i.mol2 ]; then
  [ "$i" -eq "$i" ] && continue
fi
echo "$i"
python pdbqt-mol2.py -i ../../../Bergen/bg"$i".mol2 -p ../../../Bergen/bg"$i".pdbqt -r ../bg"$i"/bg"$i"_out_ligand_1.pdbqt -o tmp/bg"$i".mol2
babel -imol2 tmp/bg"$i".mol2 -Omol2 docked-bg"$i".mol2 -h --title LIG
sed -i "s/noname11/LIG/g" docked-bg"$i".mol2

done

#python pdbqt-mol2.py -i ../../../Bergen/bg1.mol2 -p ../../../Bergen/bg1.pdbqt -r ../bg1/bg1_out_ligand_1.pdbqt -o bg1.mol2
#babel -imol2 bg1.mol2 -Omol2 test1.mol2 -h --title LIG

