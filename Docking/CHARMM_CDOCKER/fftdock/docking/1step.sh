#!/bin/bash

dir=chf-6333
lig=chf6333

## Number
copy=100
num=`ls optimized/* | wc -l | awk '{print $1}'`

mkdir result

## Docking with different grids 
$charmm num=$num copy=$copy dir=$dir lig=$lig < fftdock.inp > output_fft
cat saresult_grid.dat > result/ligand_result.dat

