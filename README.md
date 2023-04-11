# FEniCS Habrok Singularity - RUG#
### Scripts for building FEniCS on the Habrok (RUG) ###
_based on [FEniCS and Singularity](https://fenicsproject.discourse.group/t/fenics-singularity-saving-data-with-mpirun/5048/6)_
_inspired from [utwente wiki](https://hpc.wiki.utwente.nl/software:singularity) and [hardvard wiki](https://docs.rc.fas.harvard.edu/kb/singularity-on-the-cluster/)_

This collection of scripts will automatically build current releases of
[FEniCS](http://fenicsproject.org) with PETSc and all dependencies on the Peregrine HPC cluster of the University of Groningen (RUG), using Lmod modules (see the `env_build.sh` files).

## Prerequisites ##

### python 3 ###
Python 3 with [virtualenv](http://docs.python-guide.org/en/latest/dev/virtualenvs) is required.
This build uses `python 3.6.4` from the Lmod modules. 
All FEniCS related python modules will be installed within an virtual environment.
In particular, if you want to install different builds of FEniCS (different versions, 
packages (e.g., OpenMPI vs. MPICH, Intel MKL vs. OpenBLAS), or for different processor 
micro-architectures, see below), this will be helpful.

Here, [pew](https://github.com/berdario/pew) is used to manage the virtualenvs. 
To install `pew` follow these steps:
```shell
$ module load Python/3.6.4-intel-2018a
$ pip3 install pew --user
```

## Compiling instructions ##

First clone this repository, for example to the location `$HOME/dev`.

```shell
$ mkdir -p $HOME/dev && cd $HOME/dev
$ git clone https://git.web.rug.nl/P301191/FEniCS-Peregrine.git
```

### SETUP ###
The folder `intel` contains the build scripts using the intel toolchain (compilers, impi, intel MKL). 
The folder `foss` contains build scripts using the foss toolchain (gcc, openblas, openmpi). 
Select the folder according to which toolchain you want to use.
The main file is `build_all.sh`. Modify it to set the FEniCS version to be used. The `$TAG` variable 
(can be changed) specifies the directories FEniCS and its dependencies are installed to and the name of the virtual environment.
It is recommended to set `continue_on_key=true` for the first build in order to check that each dependency was installed correctly!

The script calls a number of `build_xxx.sh` scripts which download and install the corresponding applications. Edit these files to change the version, compile flags, etc.
The calls can be commented if it was already built, e.g., if a number of programs was built correctly until an error occurred in, say, `build_dolfin.sh`, because of a network timeout.

Note that if you want to rebuild everything the `$PREFIX` and the `$BUILD_DIR` dirs should be deleted, 
also the python virtual environment with `pew rm $TAG`.


Make sure the environments are correctly set in `env_build.sh` and `setup_env_fenics.env`. Also revise the individual build files.

### INSTALL ###

In order to build FEniCS run 
```shell
$ ./build_all.sh |& tee -a build.log
```
on the compute node inside the `FEniCS-Peregrine/intel` directory.

**Remark** There is an outdated folder with foss compilers. Currently is it not supported and expected to be deprecated in the future.

Wait for the build to finish. The output of
the build will be stored in `build.log` as well as printed on the screen.

## Running FEniCS ##
To activate a FEniCS build you need to source the environment file created by the build script and activate the virtualenv. 
The corresponding lines are printed after building is completed.
```shell
$ source <prefix>/bin/env_fenics_run.sh
$ pew workon fenics-<tag>
```
Now you can run python/ipython. `python -c "import dolfin"` should work. 
Try running `python poisson.py` and `mpirun -n 4 python poisson.py`.

**Remark** If installed successfully, the fenics environment created will be named *fenics-2019.1.0.post0-intel2018a*.


## Building a sif image ##
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

## Troubleshooting ##

- If an error occurs, check that the environment and the virtualenv have been correctly loaded, e.g., with `which python`, `pip show dolfin`, `pip show petsc4py` which should point to the correct versions.
- Check in the `build.log` if all dependencies were built correctly, in particular PETSc and DOLFIN. An exhaustive summary of the DOLFIN configuration is printed and should be checked.
- If python crashes with "Illegal Construction" upon `import dolfin`, one of the dependencies was probably built on a different architecture. Make sure, e.g., petsc4py is picked up from the correct location and pip did not use a cached version when installing it!
- A common error is that the `$PYTHONPATH` variable conflicts with the virtual environment, when the wrong python modules are found. To that end, in `env_build.sh` and `env_fenics_run.sh`, this variable is `unset`. Make sure it is not modified afterwards.


## Extras: On working with ParaView and Peregrine ##

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
  
