#!/bin/bash

## COMMENT THIS SECTION IF ./build_all.sh works ##
# set -e 
#source env_build.sh
# export FENICS_VERSION="2019.1.0.post0"
# export TAG="${FENICS_VERSION}-intel2018a"

# export BUILD_THREADS=1
# export PREFIX=${HOME}/dev/fenics-${TAG}
# export BUILD_DIR=${HOME}/dev/build/fenics-${TAG}

# export PYTHON_VERSION="3.6"

## --------------------------------------------- ##

mkdir -p $BUILD_DIR/tar 

export PETSC_DIR=${PREFIX}
#export SLEPC_DIR=${PREFIX}

echo "Downloading and building dolfin ${FENICS_VERSION}"

export BLA_VENDOR="Intel10_64lp"
export PYBIND11_DIR=$PREFIX

cd $BUILD_DIR && \
    git clone https://bitbucket.org/fenics-project/dolfin.git && \
    cd dolfin && \
    git checkout ${FENICS_VERSION} && \
    mkdir -p build && \
    cd build && \
    pew in fenics-${TAG} cmake .. \
       -DCMAKE_PREFIX_PATH=${PREFIX} \
       -DCMAKE_INSTALL_PREFIX=${PREFIX} \
       -DDOLFIN_USE_PYTHON3=ON \
       -DPYTHON_EXECUTABLE:FILEPATH=$(pew in fenics-${TAG} which python${PYTHON_VERSION}) \
       -DCMAKE_BUILD_TYPE="Release" \
       -DCMAKE_CXX_COMPILER=mpicxx \
       -DCMAKE_CXX_FLAGS="$CXXFLAGS" \
       -DCMAKE_C_COMPILER=mpicc \
       -DCMAKE_C_FLAGS="$CFLAGS" \
       -DDOLFIN_AUTO_DETECT_MPI=OFF \
       -DMPI_CXX_COMPILER=mpicxx \
       -DMPI_C_COMPILER=mpicc \
       -DBLA_VENDOR="Intel10_64lp" \
       -DDOLFIN_ENABLE_DOCS=OFF \
       -DCMAKE_VERBOSE_MAKEFILE=ON \
       -DDOLFIN_ENABLE_SPHINX=OFF \
       -DDOLFIN_ENABLE_UMFPACK=ON \
       -DDOLFIN_ENABLE_CHOLMOD=ON \
       -DDOLFIN_ENABLE_TRILINOS=OFF \
       -DDOLFIN_ENABLE_BENCHMARKS=ON \
       -DDOLFIN_ENABLE_VTK=OFF \
       -DZLIB_INCLUDE_DIR=${PREFIX}/include \
       -DZLIB_ROOT=${EBROOTZLIB} \
       -DEIGEN3_INCLUDE_DIR=${EBROOTEIGEN}/include \
       -DPETSC_INCLUDE_DIRS=${PREFIX}/include \
       -DPETSC4PY_INCLUDE_DIRS=$(pew in fenics-${TAG} pew sitepackages_dir)/petsc4py/include \
    2>&1 | tee cmake.log && \
    pew in fenics-${TAG} make -j ${BUILD_THREADS} && \
    pew in fenics-${TAG} make install && \
    cd $BUILD_DIR/dolfin/python && \
	DOLFIN_DIR=${PREFIX} pew in fenics-${TAG} pip3 -v install .
        # -DEIGEN3_INCLUDE_DIR:FILEPATH=${PREFIX}/include/eigen3 \
        # -DHDF5_ROOT=${EB} \
        # -DSWIG_EXECUTABLE:FILEPATH=${PREFIX}/bin/swig \
#        -DSLEPC_INCLUDE_DIRS=${PREFIX}/include \
        # -DZLIB_LIBRARY_RELEASE=${PREFIX}/lib/libz.so \

        # -DMPI_CXX_LIBRARIES=$I_MPI_ROOT/lib64 \
        # -DMPI_CXX_INCLUDE_PATH=$I_MPI_ROOT/include64 \
        # -DMPI_C_LIBRARIES=$I_MPI_ROOT/lib64 \
        # -DMPI_C_INCLUDE_PATH=$I_MPI_ROOT/include64 \

        # -DEIGEN3_INCLUDE_DIR=${EIGEN_DIR}/include \
        # -DHDF5_hdf5_LIBRARY_RELEASE=${HDF5_DIR}/lib/libhdf5.so \
        # -DMPIEXEC_MAX_NUMPROCS=120 \

        # -DCMAKE_Fortran_FLAGS="-O3 -xHost -ip -mkl" \
        # -DDOLFIN_ENABLE_PASTIX=OFF \
        # -DMPI_Fortran_COMPILER=${MPI_ROOT}/bin64/mpiifort \
        # -DDOLFIN_ENABLE_QT=OFF \
        # -DHDF5_C_COMPILER_EXECUTABLE=${HDF5_DIR}/bin/h5pcc \
        # -DZLIB_LIBRARY=${ZLIB_DIR}/lib/libz.a \
        # -DZLIB_INCLUDE_DIR=${ZLIB_DIR}/include \


if [ "$continue_on_key" = true ]; then
    echo "Press any key to continue..."
    read -n 1
fi
