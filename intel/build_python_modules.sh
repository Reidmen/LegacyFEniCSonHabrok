#!/bin/bash
source env_build.sh

## COMMENT THIS SECTION WHEN build_all.sh works without errors ##
# set -e
# export FENICS_VERSION="2019.1.0.post0"
# export TAG="${FENICS_VERSION}-intel2018a"
# export PREFIX=${HOME}/dev/fenics-${TAG}
# export BUILD_DIR=${HOME}/dev/build/fenics-${TAG}

# export PYTHON_VERSION="3.6"

## ----------------------------------------------------------- ##



export PETSC_DIR=${PREFIX}
export SLEPC_DIR=${PREFIX}

MPI4PY_VERSION=3.0.0
PETSC4PY_VERSION=3.11.0 

# pew in fenics-${TAG} pip3 install -I numpy scipy  && \
# pew in fenics-${TAG} \
#     pip3 install -I --no-cache-dir https://bitbucket.org/mpi4py/mpi4py/downloads/mpi4py-${MPI4PY_VERSION}.tar.gz && \
pew in fenics-${TAG} \
    pip3 install -I --no-cache-dir https://bitbucket.org/petsc/petsc4py/downloads/petsc4py-${PETSC4PY_VERSION}.tar.gz && \
pew in fenics-${TAG} pip3 install -I ruamel.yaml gitpython sympy==1.1.1 ipython mpi4py scipy
# pew in fenics-${TAG} \
    # pip3 install -I --no-cache-dir https://bitbucket.org/slepc/slepc4py/downloads/slepc4py-${SLEPC4PY_VERSION}.tar.gz && \

if [ "$continue_on_key" = true ]; then
    echo "Press any key to continue..."
    read -n 1
fi
