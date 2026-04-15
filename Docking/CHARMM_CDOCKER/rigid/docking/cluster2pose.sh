#!/bin/bash

export mol=tc

final=12
for((i=1;i<=final;i++))
do
if [[ ! -d "$mol""$i" ]]; then
echo $mol$i "directory doesn't exists"
else

#sort -g -k 2 "$mol""$i"/dock_result/result/sorted_total.dat > "$mol""$i"/dock_result/result/final.dat

END=`wc -l "$mol""$i"/dock_result/result/final.dat | awk '{print $1}'`
for((j=1;j<=END;j++))
do
export k=`cat "$mol""$i"/dock_result/result/final.dat | sed -n "$j p" | awk '{print $1}'`
echo $k
cp "$mol""$i"/dock_pose/total_"$k".pdb "$mol""$i"/dock_pose/"$mol""$i"_p"$j".pdb
done
fi
done

