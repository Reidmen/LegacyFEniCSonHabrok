#!/bin/bash
#SBATCH --job-name=sing_test
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=8
#SBATCH --time=00:05:00
#SBATCH --mem=4000 

echo "STARTING JOB"
echo "OS_RELEASE"
singularity exec legacy_fenics.sif cat /etc/os_release
echo "EXECUTING DEMO"
singularity exec legacy_fenics.sif python3 demos/demo_cahn_hilliard.py
