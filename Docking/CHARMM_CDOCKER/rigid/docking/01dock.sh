#!/bin/bash

## Number
num=10
copy=100
total=$[copy * num * 100]
cSize=`ls optimized/* | wc -l | awk '{print $1}'`
trial=`expr $cSize / $num`
reminder=`expr $cSize % $num`


echo "Did you translate the ligand then, edit openmm_rigid.inp"
echo "Check openmm_rigid.inp for which ligand coordinates to read"

## Docking with different grids 
for idx in `seq 0 $trial`; do
        if [ $idx -eq $trial ] && [ $reminder -gt 0 ]; then
                $charmm trial=$trial factor=$num num=$reminder copy=$copy total=$total dir=$dir lig=$lig < ../openmm_rigid.inp > output_${idx}
                cat initial.dat >> result/initial.dat
                cat saresult_grid.dat >> result/ligand_result.dat
        elif [ $idx -lt $trial ]; then
                $charmm trial=$idx factor=$num num=$num copy=$copy total=$total dir=$dir lig=$lig < ../openmm_rigid.inp > output_${idx}
                cat initial.dat >> result/initial.dat
                cat saresult_grid.dat >> result/ligand_result.dat
                fi
        done
