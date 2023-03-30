#!/bin/bash

# exit on error
set -e

# FEniCS version
# Currently available:
#	* master	 (development version)
#	* 2019.1.0.post0 (last stable build)

# Load all required compilers whenever build_cmake.sh is not used
source env_build.sh


# FENICS version
export FENICS_VERSION="2019.1.0.post0"
# export FENICS_VERSION="master"

# TAG that specifies the name of the build directories and the virtualenv
export TAG="${FENICS_VERSION}-intel2018a"

export BUILD_THREADS=1
export PREFIX=${HOME}/dev/fenics-${TAG}
export BUILD_DIR=${HOME}/dev/build/fenics-${TAG}
mkdir -p ${PREFIX}

export PYTHON_VERSION="3.6"

# set this to true in order to wait after each module
export continue_on_key=true

echo "Installing FEniCS to ${PREFIX}"

./build_cmake.sh 
./setup_virtualenv.sh 
./build_petsc.sh
./build_slepc.sh
# # ./build_eigen.sh    # replace this by system modules?
./build_python_modules.sh
./build_fenics_pymodules.sh  # ffc fiat ufl uflacs instant
./build_pybind11.sh
./build_dolfin.sh
#./build_mshr.sh # taken out, need to be updated
./setup_fenics_env.sh

# run with $ ./build_all.sh |& tee -a build.log
