#!/bin/bash

export charmm=/Data/cbu/cbureuterfs/pga043/charmm/49a1_blade/charmm/build_charmm/charmm

run=lig54
lig=lig54
seg=MOL

$charmm run=$run lig=$lig seg=$seg seed=$RANDOM -i setup_restraints.inp
$charmm run=$run lig=$lig seg=$seg -i setup_restraints1.inp
$charmm run=$run lig=$lig seg=$seg -i setup_restraints2.inp
