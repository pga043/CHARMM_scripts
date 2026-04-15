#!/bin/bash


export charmm=/net/orinoco/pga043/CHARMM_47a2/charmm_47a2/build_openmm_blade/charmm 

#$charmm -i write_pdb.inp > write_pdb.out

$charmm -i gridcenter.inp > gridcenter.out
