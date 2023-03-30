#!/bin/bash
source env_build.sh

HDF5_VERSION="1.10.2"

echo "Downloading and building HDF5 ${HDF5_VERSION}"

mkdir -p ${BUILD_DIR}/tar

# use curl instead of wget because of openSSL errors
#   wget --quiet --read-timeout=10 -nc -P tar https://www.hdfgroup.org/ftp/HDF5/releases/hdf5-${HDF5_VERSION}/src/hdf5-${HDF5_VERSION}.tar.bz2 && \
cd ${BUILD_DIR} && \
    curl --connect-timeout 10 -o tar/hdf5-${HDF5_VERSION}.tar.gz https://support.hdfgroup.org/ftp/HDF5/releases/hdf5-${HDF5_VERSION%\.*}/hdf5-${HDF5_VERSION}/src/hdf5-${HDF5_VERSION}.tar.gz && \
   tar xzf tar/hdf5-${HDF5_VERSION}.tar.gz && \
   cd hdf5-${HDF5_VERSION} && \
   CC=mpicc ./configure --enable-parallel --prefix=${PREFIX} --with-zlib=${EBROOTZLIB} --with-szlib=${EBROOTSZIP} && \
   make -j ${BUILD_THREADS} && \
   make install

if [ "$continue_on_key" = true ]; then
    echo "Press any key to continue..."
    read -n 1
fi
