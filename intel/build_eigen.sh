#!/bin/bash
source env_build.sh

## COMMENT WHEN ./build_all.sh WORKS WITHOUT PROBLEMS ##

export FENICS_VERSION="2019.1.0.post0"
export TAG="${FENICS_VERSION}-intel2018a"

export BUILD_THREADS=1
export PREFIX=${HOME}/dev/fenics-${TAG}
export BUILD_DIR=${HOME}/dev/build/fenics-${TAG}


## -------------------------------------------------- ##

VERSION="3.3.4"

echo "Downloading and building EIGEN ${VERSION}"

mkdir -p $BUILD_DIR/tar

cd ${BUILD_DIR} && \
   wget --quiet --read-timeout=10 -nc http://bitbucket.org/eigen/eigen/get/${VERSION}.tar.bz2 -O tar/eigen.tar.bz2 && \
   mkdir -p ${BUILD_DIR}/eigen && \
   tar -xf tar/eigen.tar.bz2 -C ${BUILD_DIR}/eigen --strip-components=1 && \
   cd eigen && \
   mkdir -p build && \
   cd build && \
   cmake ../ -DCMAKE_INSTALL_PREFIX=${PREFIX} && \
   make install


if [ "$continue_on_key" = true ]; then
    echo "Press any key to continue..."
    read -n 1
fi
