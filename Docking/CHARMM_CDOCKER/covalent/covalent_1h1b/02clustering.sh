#!/bin/bash

cSize=`ls optimized/* | wc -l | awk '{print $1}'`

## Clustering
rm -f conformer_cluster.log
for conformer in `seq 1 $cSize`; do
	rm -f tmpcluster

	## Search cluster radius
	for idx in `seq 5 20`; do
		radius=`echo "scale=2; $idx / 10" | bc`
		cluster.pl -kclust -nolsqfit -radius $radius -selmode heavy ${conformer}_* > cluster.log
		total=`grep @cluster cluster.log | sed 1d | sort -nk 4 | tail -n 1 | awk '{print $4}'`
		echo $total $radius >> tmpcluster
		done

	## Find the best clustering radius for a given conformer
	total=`sort -gk 1 tmpcluster | tail -n 1 | awk '{print $1}'`
	radius=`awk '{if ($1 == size) print $2}' size=$total tmpcluster | sort -gk 2 | head -n 1`
	echo $conformer $total $radius >> conformer_cluster.log

	## Find the minimum energy pose in the largest cluster for a given conformer
	cluster.pl -kclust -nolsqfit -radius $radius -selmode heavy ${conformer}_* > cluster.log
	init=`grep @cluster cluster.log | sed 1d | sort -nk 4 | tail -n 1 | awk '{print $2}' | cut -b 3-`
	final=$[init+1]
	awk "/cluster t.$init /, /cluster t.$final / {print}" cluster.log | sed /cluster/d | awk '{print $2}' > tmp
	rm -f tmp2.dat
	for id in `cat tmp`; do
		pdb=`echo $id | sed s/.pdb//g`
		awk '{if ($1==name) print}' name=$pdb result/ligand_result.dat >> tmp2.dat
		done
	sort -gk 2 tmp2.dat | head -n 1 >> sorted_total.dat
	total=`sort -gk 2 tmp2.dat | head -n 1 | awk '{print $1}'`
	cp ${total}.pdb dock_pose/total_${total}.pdb

	done

## Save top rank poses
for total in `sort -gk 2 sorted_total.dat | head -n 10 | awk '{print $1}'`; do
	cp dock_pose/total_${total}.pdb result
	done
mv conformer_cluster.log sorted_total.dat result

# Clean folder
mv result dock_result/
mkdir -p pdbs
mv *.pdb pdbs/
