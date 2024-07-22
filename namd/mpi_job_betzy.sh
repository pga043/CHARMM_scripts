#!/bin/bash

#SBATCH --account=
#SBATCH --job-name=HNE-mol53

#SBATCH --time=80:00:00
##SBATCH --mem-per-cpu=1G
#SBATCH --exclusive

#SBATCH --nodes=4  # for normal job, use 8~256 nodes
#SBATCH --ntasks-per-node=64 # max.128 cores each note

namdconfig=prod  # pass the configuration file in the command line

## Recommended safety settings:
set -o errexit # Make bash exit on any error
set -o nounset # Treat unset variables as errors

## Software modules
module --quiet purge
module load foss/2020a
module list   # List loaded modules, for easier debugging


# use the NAMD built in our own project folder
namdbin=path_to_namd_executable

mpirun -bind-to core $namdbin ${namdconfig}.conf > ${namdconfig}.out
