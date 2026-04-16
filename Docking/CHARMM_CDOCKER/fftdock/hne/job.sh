#!/bin/bash
#SBATCH --nodes=1 
#SBATCH --job-name=charmm
#SBATCH --partition=gpu
#SBATCH --gres=gpu:1 
#SBATCH --ntasks=4
##SBATCH --mem-per-cpu=2G 
#SBATCH --time=05:00:00
#SBATCH --output=slurm.out

#===============================================
ml load openmm/7.6.0 #gcc/10.2.0 fftw/3.3.8 cuda/11.2
ml load openmpi/3.1.2-gcc-10.2.0 

export charmm=/home/pgartan/src/charmm/build_openmm/charmm 

#$charmm -i write_pdb.inp > write_pdb.out

$charmm -i gridcenter.inp > gridcenter.out
