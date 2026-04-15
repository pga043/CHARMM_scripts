#!/bin/bash

#END=144
#for((i=4;i<=END;i++))
for i in 47 52 55 56 57 58 94
do
#if [ ! -f $mol$i/$mol$i.mol2 ]; then
#   [ "$i" -eq "$i" ] && continue
#fi
#[ "$i" -eq 81 ] && continue

#sort -g -k 2 "$mol""$i"/dock_result/result/sorted_total.dat > "$mol""$i"/dock_result/result/final.dat

#export j=`wc -l "$mol""$i"/dock_result/result/final.dat | awk '{print $1}'`

#end=$j
#for((k=1;k<=end;k++))
#do
#echo $k
#export t=`awk '{print $1}' "$mol""$i"/dock_result/result/final.dat | sed -n ''$k'p'`
#echo set a"$k" = $t >> "$mol""$i"/dock_result/result/varibales.dat
#done

export p=`awk '{print $1}' "$mol""$i"/dock_result/result/final.dat | sed -n '1p'`
#echo $p
export end=`wc -l "$mol""$i"/dock_result/result/final.dat | awk '{print $1}'`

#$charmm top=$p end=$end dir=$mol$i lig=$mol$i -i rmsd.inp > "$mol""$i"/dock_result/result/rmsd.out
#$charmm end=$end prot=$prot enzyme=$enzyme dir=$mol$i lig=$mol$i -i distance.inp > "$mol""$i"/dock_result/result/distance.out

$charmm top=$p end=$end dir=$mol$i lig=$mol$i -i vina_rmsd.inp > "$mol""$i"/dock_result/result/vina_rmsd.out
#----------------------------------------------
#printing maximum rmsd within an energy cutoff
# energy cutoff <= 2 kcal/mol
# rmsd cutoff >= 1.5 angstroms 

#export q=`awk '{print $2}' "$mol""$i"/dock_result/result/final.dat | sed -n '1p'`

#paste "$mol""$i"/dock_result/result/docked_rmsd.dat "$mol""$i"/dock_result/result/final.dat | awk '{print $1, $2, $5-'$q'}' > "$mol""$i"/dock_result/result/relative-rmsd-energy.dat

## relative energy <= 2kcal/mol | relative rmsd >= 1.5 
#awk '$3 <= 2' "$mol""$i"/dock_result/result/relative-rmsd-energy.dat | awk '$2 >= 1.5' > lookatus/"$mol""$i".dat 

done
