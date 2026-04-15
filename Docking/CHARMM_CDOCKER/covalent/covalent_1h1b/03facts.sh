#!/bin/bash

############################################################################################
## Calculate energy with facts
############################################################################################

export j=result

# Check if flexible docking is success
if [ -s dock_result/${j}/ligand_result.dat ] && [ -s dock_result/${j}/sorted_total.dat ] && [ ! -s dock_result/${j}/facts_energy ]; then

        ## Prepare charmm scripts
#        atom=`grep 'ATOM' "$dir"/"$lig".str | grep 'CG2O1' | awk '{print $2}'`
#        sed -i s/ACCEPTOR/$atom/g facts.inp

## get the names of carbonyl carbon and oxygen using str file
        #export carbon=`grep 'ATOM' "$dir"/"$lig".str | grep 'CG2O1' | awk '{print $2}'`
        #export oxygen=`grep "$carbon" "$dir"/"$lig".str | grep 'BOND' | grep -E '(O1|O2|O3|O4|O5)' | awk '{print $3}'`

        #echo $j ACCEPTOR $atom >> run.log

        # Compute energy
        rm -f facts_energy
        for id in `sort -gk 2 dock_result/${j}/sorted_total.dat | head -n 10 | awk '{print $1}'`; do
                $charmm prot=$prot enzyme=$enzyme dir=$dir lig=$lig idx=$j i=$id < ../facts.inp > output_facts
                cat energy.dat >> facts_energy
                done

        # Save result
        mv facts_energy dock_result/${j}

        fi

