#!/bin/bash

#***********************************************************************************************************
#-----------------------------------------------------------------------------------------------------------
namd3=/Home/siv32/pga043/Software/NAMD_3.0.2_Source/Linux-x86_64-g++/namd3

mkdir -p logs fepout

#sed -i -e "s/set iseed/set iseed  "$RANDOM"/" equil.namd

#$namd3 +p32 +devices 0 equil.namd > logs/equil.log 
#$namd3 +p32 +devices 0 forward-off.namd > logs/forward-off.log
$namd3 +p32 +devices 0 backward-off.namd > logs/backward-off.log

exit 0 
