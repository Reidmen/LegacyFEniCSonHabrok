# FEniCS Habrok Singularity

### Scripts for building FEniCS on the Habrok
_based on [FEniCS and Singularity](https://fenicsproject.discourse.group/t/fenics-singularity-saving-data-with-mpirun/5048/6)_
_inspired from [utwente wiki](https://hpc.wiki.utwente.nl/software:singularity) and [harvard wiki](https://docs.rc.fas.harvard.edu/kb/singularity-on-the-cluster/)_

## Prerequisites
Singularity in your HPC. To check availability, you can check by typing `module avail`.

## BUILDING INSTRUCTIONS

First clone this repository, for example to the location `$HOME`.

```shell
cd $HOME
git clone https://github.com/Reidmen/LegacyFEniCSonHabrok.git
```

## Building a SIF image

To build an singularity file, its required to provide a name (e.g. *fenics-openmpi.sif*), its recipe
located in `singularity/fenics-openmpi.recipe` call the `build` command as described below.

```shell
cd singularity
singularity build fenics-openmpi.sif fenics-openmpi.recipe
```

An alternative, is to directly specifiy the source. An OpenMPI version is available in `reidmen/fenics-openmpi:latest`.
To convert it to `.sif` you can directly build with the command:

```shell
cd singularity
singularity build fenics-openmpi.sif docker://reidmen/fenics-openmpi:latest
```

## Executing demo file

In order for OpenMPI to work properly, we need to export the following:
```shell
export OMPI_MCA_btl_vader_single_copy_mechanism=none
```

To execute a python script, its required to start a shell session and execute the script as described below.

```shell
singularity shell fenics-openmpi.sif
python3 singularity/demo_poisson_mpi_test.py
```

As alternative, to execute in paralell its enough to call `mpirun` within the container.
```shell
mpirun -n 8 python3 singularity/demo_poisson_mpi_test.py
```

## Submit jobs to Habrok
To submit jobs to Peregrine, you need to provide a minimal configuration using sbatch, export the variables above and activate the environment, e.g.
```bash
#!/bin/bash
#SBATCH --job-name=singularity_test
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=8
#SBATCH --time=00:05:00
#SBATCH --mem=4000 

module load OpenMPI

export OMP_NUM_THREADS=6
export OMPI_MCA_btl_vader_single_copy_mechanism=none

echo "EXECUTING DEMO"
# singularity run fenics-openmpi.sif cat /etc/os-release
mpirun -n $OMP_NUM_THREADS singularity exec fenics-openmpi.sif python3 -c "from dolfin import *; print(MPI.comm_world.rank)"
```

If successful, the output should enumerate the threads being requested in the job.
