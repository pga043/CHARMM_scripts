#!/bin/bash
#SBATCH --nodes=1 
#SBATCH -N 1
#SBATCH --job-name=FFTDock
#SBATCH --partition=gpu
#SBATCH --gres=gpu:1 
#SBATCH --mem-per-cpu=2G 
#SBATCH --time=04:00:00
##SBATCH --output=test

ml load openmm/7.6.0 #gcc/10.2.0 fftw/3.3.8 cuda/11.2
ml load openmpi/3.1.2-gcc-10.2.0
ml load openbabel/2.4.1
ml load cgenff/2022.1

#module load openbabel/2.4.1
module load mmtsb/mmtsb
module load anaconda/3.5.3.0

export charmm=/home/pgartan/src/charmm/build_openmm/charmm

## Prepare ligand
#bash 0step.sh

## prepare protein grid(s)
#bash grid.sh

## Generate ligand random conformer
#bash prepare.sh

## run fftdock
bash 1step.sh

#cluster
bash 2step.sh

#clean directory
mv conformer cluster.log conformer.py dockresult/ dock_pose/ genGrid.out *.bin maxlen optimized/ output_* pdbs/ saresult_grid.dat slurm* tmp* chf-6333/

 mv conformer.py.original conformer.py

#############
