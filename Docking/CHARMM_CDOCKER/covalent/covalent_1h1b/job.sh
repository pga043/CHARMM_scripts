#!/bin/bash

export charmm=/net/orinoco/pga043/charmm/49a1_blade/charmm/build_charmm/charmm 

##*****************
echo '****************'
echo check donor acceptor definitions for protein and ligand
echo check donor/acceptor atom definition in 03dock.sh
echo 
echo '****************'
##******************

for i in 72 105
#while read i
do
echo "$i"

# change for ligand
export mol=bg
export dir=.
export lig="$mol""$i"

#change for proteins
export xcen=`cat ../1h1b/xcen`
export ycen=`cat ../1h1b/ycen`
export zcen=`cat ../1h1b/zcen`
export x_center=`cat ../1h1b/xcen`
export y_center=`cat ../1h1b/ycen`
export z_center=`cat ../1h1b/zcen`
export prot=1h1b
export enzyme=swiss1

rm -rf "$lig"
mkdir -p "$lig"
cd "$lig"

cp /net/orinoco/pga043/AnnArbor/dockings/rigid_hne/"$lig"/"$lig".pdb .
cp /net/orinoco/pga043/AnnArbor/dockings/rigid_hne/"$lig"/"$lig".mol2 .
cp /net/orinoco/pga043/AnnArbor/dockings/rigid_hne/"$lig"/"$lig".rtf .
cp /net/orinoco/pga043/AnnArbor/dockings/rigid_hne/"$lig"/"$lig".prm .
cp /net/orinoco/pga043/AnnArbor/dockings/rigid_hne/"$lig"/"$lig".str .

#==========================#
# run files ####

#------ part 1 ---------
mkdir -p dock_result result dock_pose conformer

bash ../ligand.sh

export max_len=`cat maxlen`
bash ../grid.sh

##------ part 2 ----------

bash ../prepare.sh
mv conformer.dat result/ligand_internal
rm  tmp*

#------ part 3 ----------
bash ../01dock.sh

bash ../02clustering.sh

bash ../03facts.sh
#----------------------

rm -rf pdbs tmp* output_*  *.bin

## ******* not required *****************
## clean the directory ##
#mv cluster.log conformer conformer.py dock_* genGrid.out initial.dat ligand_rotamer.crd maxlen mini.crd optimized/ output_* saresult_grid.dat slurm* tmp* *.bin pdbs "$dir"/

#mv conformer.py.original conformer.py
###########################

cd ../

done
#done < <(sed '1,7d' /net/orinoco/pga043/AnnArbor/forPR3_NE_paper/dimethyl.txt | awk '{print $1}')

