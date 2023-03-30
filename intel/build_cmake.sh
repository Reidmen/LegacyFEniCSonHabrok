#!/bin/bash
source env_build.sh

## COMMENT THIS SECTION WHEN ./build_all.sh works without errors ## 
#set -e 
#export FENICS_VERSION="2019.1.0.post0"
#export TAG="${FENICS_VERSION}-intel2018a"
#
#export BUILD_THREADS=1
#export PREFIX=$HOME/dev/fenics-${TAG}
#export BUILD_DIR=${HOME}/dev/build/fenics-${TAG}
#
#export PYTHON_VERSION="3.6"
#
## ------------------------------------------------------------- ##

CMAKE_VERSION="3.11.1"

echo "Downloading and building CMAKE ${CMAKE_VERSION}"

mkdir -p $BUILD_DIR/tar

cd ${BUILD_DIR} && \
   wget --quiet --read-timeout=10 -nc -P tar https://cmake.org/files/v${CMAKE_VERSION%\.*}/cmake-${CMAKE_VERSION}.tar.gz && \
   tar -xzf tar/cmake-${CMAKE_VERSION}.tar.gz && \
   cd cmake-${CMAKE_VERSION} && \
   CC=gcc CXX=g++ CFLAGS='' CXXFLAGS='' ./bootstrap --prefix=${PREFIX} && \
   make -j${BUILD_THREADS} && \
   make install


if [ "$continue_on_key" = true ]; then
    echo "Press any key to continue..."
    read -n 1
fi
