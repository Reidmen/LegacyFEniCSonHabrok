#!/bin/bash
source env_build.sh

## COMMENT THIS SECTION WHEN ./build_all.sh works without errors ##
# set -e 
# export FENICS_VERSION="2019.1.0.post0"
# export TAG="${FENICS_VERSION}-intel2018a"

# export BUILD_THREADS=1
# export PREFIX=${HOME}/dev/fenics-${TAG}
# export BUILD_DIR=${HOME}/dev/build/fenics-${TAG}

# export PYTHON_VERSION="3.6"

## ------------------------------------------------------------- ##



SLEPC_VERSION="3.11.2"

echo "Downloading and building SLEPc ${SLEPC_VERSION}"

mkdir -p $BUILD_DIR/tar

cd ${BUILD_DIR} && \
   wget --quiet --read-timeout=10 -nc http://slepc.upv.es/download/distrib/slepc-${SLEPC_VERSION}.tar.gz -O tar/slepc-${SLEPC_VERSION}.tar.gz && \
   tar -xzf tar/slepc-${SLEPC_VERSION}.tar.gz && \
   cd slepc-${SLEPC_VERSION} && \
   python2 ./configure --prefix=${PREFIX} && \
   make SLEPC_DIR=$PWD PETSC_DIR=${PREFIX} MAKE_NP=${BUILD_THREADS} && \
   make SLEPC_DIR=${BUILD_DIR}/slepc-${SLEPC_VERSION} PETSC_DIR=${PREFIX} install

#   python2 ./configure --prefix=${PREFIX} && \
#   make MAKE_NP=${BUILD_THREADS} && \
#   make install


if [ "$continue_on_key" = true ]; then
    echo "Press any key to continue..."
    read -n 1
fi


