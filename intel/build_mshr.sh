#!/bin/bash
source env_build.sh

## COMMENT WHEN ./build_all.sh WORKS WITHOUT ERRORS ##

export FENICS_VERSION="2019.1.0.post0"
export TAG="${FENICS_VERSION}-intel2018a"

export BUILD_THREADS=1
export PREFIX=${HOME}/dev/fenics-${TAG}
export BUILD_DIR=${HOME}/dev/build/fenics-${TAG}

export PYTHON_VERSION="3.6"

## ------------------------------------------------ ##

mkdir -p $BUILD_DIR/tar

export PETSC_DIR=${PREFIX}
export MSHR_VERSION="2019.1.0"

export CFLAGS="-O2 -march=native"
export CXXFLAGS="-O2 -march=native"

echo "Downloading and building mshr $MSHR_VERSION"

cd $BUILD_DIR && \
    #git clone https://bitbucket.org/fenics-project/mshr.git && \
    cd mshr && \
    git checkout $MSHR_VERSION && \
    mkdir -p build && \
    cd build && \
    pew in fenics-${TAG} cmake .. \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_INSTALL_PREFIX=${PREFIX} \
        -DMPFR_INCLUDE_DIR=${EBROOTMPFR}/include \
        -DMPFR_LIBRARIES=${EBROOTMPFR}/lib/libmpfr.so \
        -DEIGEN3_INCLUDE_DIR=${EBROOTEIGEN}/include \
        -DGMP_INCLUDE_DIR=${EBROOTGMP}/include \
        -DGMP_LIBRARIES=${EBROOTGMP}/lib/libgmp.so \
        -DGMP_LIBRARIES_DIR=${EBROOTGMP}/lib && \
    pew in fenics-${TAG} make -j ${BUILD_THREADS} && \
    pew in fenics-${TAG} make install && \
    cd ../python/ && \
    pew in fenics-${TAG} python setup.py install


if [ "$continue_on_key" = true ]; then
    echo "Press any key to continue..."
    read -n 1
fi
