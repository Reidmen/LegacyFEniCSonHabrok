#!/bin/bash
source env_build.sh

## COMMENT THIS SECTION WHEN ./build_all.sh works without errors ## 
# export FENICS_VERSION="2019.1.0.post0"
# export TAG="${FENICS_VERSION}-intel2018a"

# export BUILD_THREADS=4
# export PREFIX=${HOME}/dev/fenics-${TAG}
# export BUILD_DIR=${HOME}/dev/build/fenics-${TAG}

# export PYTHON_VERSION="3.6"

#mkdir -p ${PREFIX}

## ------------------------------------------------------------- ##


mkdir -p $BUILD_DIR/tar

PYBIND11_VERSION="2.2.4"

echo "Downloading and building pybind11 $PYBIND11_VERSION"


cd ${BUILD_DIR} && \
wget --read-timeout=10 -nc \
    https://github.com/pybind/pybind11/archive/v${PYBIND11_VERSION}.tar.gz -O \
    tar/pybind11.tar.gz && \
   mkdir -p ${BUILD_DIR}/pybind11 && \
   tar -xf tar/pybind11.tar.gz -C ${BUILD_DIR}/pybind11 --strip-components=1 && \
   cd pybind11 && \
   pew in fenics-${TAG} mkdir -p build && \
   cd build && \
   pew in fenics-${TAG} cmake .. \
	-DPYBIND11_TEST=False \
	-DCMAKE_INSTALL_PREFIX=${PREFIX} && \
   pew in fenics-${TAG} make && \
   pew in fenics-${TAG} make install
