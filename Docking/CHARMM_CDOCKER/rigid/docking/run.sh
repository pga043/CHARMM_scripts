#!/bin/bash

#export charmm=/Data/cbu/cbureuterfs/pga043/charmm/49a1_blade/charmm/build_charmm/charmm
export charmm=/Data/cbu/cbureuterfs/pga043/charmm/c50b2/charmm/build_charmm/charmm

while read i
do
echo "$i"

# change for ligand
export mol="$i"
export dir=.
export lig="$mol"

#change for proteins
export xcen=`cat ../8r1v/xcen`
export ycen=`cat ../8r1v/ycen`
export zcen=`cat ../8r1v/zcen`
export x_center=`cat ../8r1v/xcen`
export y_center=`cat ../8r1v/ycen`
export z_center=`cat ../8r1v/zcen`
export prot=8r1v
export enzyme=dimer

#rm -rf "$mol"
mkdir -p "$mol"
cd "$mol"
#cp ../"$mol".mol2 .
cp /Data/cbu/cbureuterfs/pga043/postdoc/fabf/msld/eos/batch2/"$mol".mol2 .
ln -s ../../toppar* .

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
#----------------------

###########################

cd ../

#done

done < <(cat mol_list.txt)

