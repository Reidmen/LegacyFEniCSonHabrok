# FEniCS Habrok Singularity - RUG#
### Scripts for building FEniCS on the Habrok (RUG) ###
_based on [FEniCS and Singularity](https://fenicsproject.discourse.group/t/fenics-singularity-saving-data-with-mpirun/5048/6)_
_inspired from [utwente wiki](https://hpc.wiki.utwente.nl/software:singularity) and [hardvard wiki](https://docs.rc.fas.harvard.edu/kb/singularity-on-the-cluster/)_

## Prerequisites ##
Singularity in your HPC. To check availability, you can check by typing `module avail`.

## BUILDING INSTRUCTIONS ##

First clone this repository, for example to the location `$HOME`.

```shell
$ cd $HOME
$ git clone https://github.com/Reidmen/LegacyFEniCSonHabrok.git
```

### BUILD (NOT UPDATED) ###

In order to build FEniCS run 
```shell
$ ./build_all.sh |& tee -a build.log
```
on the compute node inside the `FEniCS-Peregrine/intel` directory.

**Remark** There is an outdated folder with foss compilers. Currently is it not supported and expected to be deprecated in the future.

Wait for the build to finish. The output of
the build will be stored in `build.log` as well as printed on the screen.

## Building a SIF image ##
To build an singularity file, its required to provide a name (e.g. *legacy_fenics.sif*), its recipe
located on `singularity/legacy_fenics.recipe` call the `build` command as described below.

```shell
$ cd singularity
$ singularity build legacy_fenics.sif legacy_fenics.recipe
```

## Executing demo file ##

To execute a python script, its required to start a shell session and execute the script as described below.

```shell
$ singularity shell legacy_fenics.sif
$ mkdir -p ouput
$ python3 demos/demo_cahn_hilliard.py
```

As alternative, to execute in paralell its enough to call `mpirun` within the container.
```shell
$ mpirun -n 4 python3 demos/demo_cahn_hilliard.py
```

## Submit jobs to Habrok ##
To submit jobs to Peregrine, you need to provide a minimal configuration using sbatch, 
activate the environment, e.g.
```bash
#!/bin/bash
#SBATCH --job-name=sing_test
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=4
#SBATCH --time=00:05:00
#SBATCH --mem=4000 

# Load compilers and FEniCS environment variables
source $HOME/dev/fenics-2019.1.0.post0-intel2018a/bin/env_fenics_run.sh 
export I_MPI_PMI_LIBRARY=/usr/lib64/libpmix.so
echo "STARTING JOB"
echo "OS_RELEASE"
singularity exec legacy_fenics.sif cat /etc/os_release
echo "EXECUTING DEMO"
# executes the code in parallel using the configuration above
singularity exec legacy_fenics.sif python3 demos/demo_cahn_hilliard.py
```

## Extras: On working with ParaView and Peregrine (NOT UPDATED)##

To run ParaView on the Peregrine sever:
1. Run a pvsever on Peregrine, using the SLURM script below, choosing an arbitrary port number, e.g. 11111.

2. As the job starts to run, check on which node it runs (either with `squeue` or by looking up the job output line like `Accepting connection(s): pg-node005:222222`.

3. Open an ssh forward tunner connecting you directly to the respective node, e.g.
    ```shell
    ssh -N -L 11111:pg-node005:222222 username@peregrine.hpc.rug.nl
    ```
    This will forward the connection to the indicated node using the local port 11111 (your machine) and the target port 222222 (computing node).

4. Open ParaView 5.4.1 (version must match the current version on Peregrine, note that ParaView from the Ubuntu standard repositories does not work with this and ParaView must be [downloaded](https://www.paraview.org/download/) instead.

5. Choose "Connect" from the top left corner, add a new server with properties client / server, localhost, port 11111 (default values). Connect to that server.

6. If successful, you can now open files directly from the server and view them in decomposed state.

**SLURM script**
```bash
#!/bin/bash
#SBATCH -p short
#SBATCH --nodes=1
#SBATCH -J ParaView
#SBATCH -n 4
#SBATCH --mem-per-cpu=4000
#SBATCH --time=00-00:30:00

#SBATCH -o paraview_%j

module load ParaView/5.4.1-foss-2018a-mpi

srun -n 4 pvserver --use-offscreen-rendering --disable-xdisplay-test --server-port=222222

```
  
