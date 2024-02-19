#!/bin/bash

export charmm=/net/orinoco/pga043/CHARMM_47a2/charmm_47a2/build_openmm_blade/charmm 

export mol=6
export seg=XRAY

export dir=5ag5
export run="$dir"/mol"$mol"/trial1
export lig="$mol"
export prot=5ag5_prot

#$charmm dir=$dir lig=$lig seg=$seg run=$run -i build_ligand.inp > $run/build_ligand.out
#$charmm dir=$dir run=$run lig=$lig prot=$prot seg=$seg -i complex.inp > $run/complex.out
#$charmm dir=$dir run=$run lig=$lig prot=$prot -i  init-mini.inp > $run/init-mini.out
#$charmm dir=$dir run=$run lig=$lig prot=$prot -i  solvate.inp > $run/solvate.out

export box=`grep 'GREATERVALUE' $run/solvate.out | head -n 1 | awk '{print $4}' | sed 's/^"\(.*\)"$/\1/'`
echo $box
export fft=`python fft.py $box`
echo $fft

#$charmm dir=$dir run=$run lig=$lig prot=$prot box=$box fft=$fft -i neutralize.inp > $run/neutralize.out
#$charmm dir=$dir run=$run lig=$lig prot=$prot box=$box fft=$fft -i final-mini.inp > $run/final-mini.out

#echo 'set iseed = ' `date +%H%M%S` > $run/seed.stream

#mpirun -np 10 $charmm dir=$dir run=$run lig=$lig prot=$prot box=$box fft=$fft iseed=$RANDOM -i heat.inp > $run/heat.out 

#$charmm dir=$dir run=$run lig=$lig prot=$prot box=$box fft=$fft -i charmm_equil.inp > $run/charmm_equil.out
#$charmm dir=$dir run=$run lig=$lig prot=$prot box=$box fft=$fft -i charmm_prod.inp > $run/charmm_prod.out

#---------------------------------------------------
#---------------------------------------------------
$charmm dir=$dir run=$run lig=$lig prot=$prot box=$box fft=$fft -i orient.inp #> $run/orient.out

#$charmm dir=$dir run=$run lig=$lig prot=$prot seg=$seg -i hbonds.inp > $run/hbonds.out

#$charmm dir=$dir run=$run lig=$lig prot=$prot seg=$seg -i 1_anchor_atoms.inp 
