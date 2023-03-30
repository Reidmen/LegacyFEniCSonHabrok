#!/bin/bash
source env_build.sh

## COMMENT THIS SECTION WHEN ./build_all.sh WORKS WITHOUT ERRORS ## 

# export FENICS_VERSION="2019.1.0.post0"
# export TAG="${FENICS_VERSION}-intel2018a"

# export BUILD_THREADS=1

# export PREFIX=${HOME}/dev/fenics-${TAG}
# export BUILD_DIR=${HOME}/dev/build/fenics-${TAG}

# export PYTHON_VERSION="3.6"

## ------------------------------------------------------------- ##

pew in fenics-${TAG} pew add ${PREFIX}/lib/python${PYTHON_VERSION}/site-packages
# pew in fenics-${TAG} pew add ${PREFIX}/lib64/python${PYTHON_VERSION}/site-packages

mkdir -p ${PREFIX}/bin

# Copy fenics environment for intel modules to fenics-`tag`/bin
if [ -f "${PREFIX}/bin/env_fenics_run.sh" ]; then
    cp ${PREFIX}/bin/env_fenics_run.sh ${PREFIX}/bin/env_fenics_run.sh.bak
fi
if [ -f "${PREFIX}/bin/env_build.sh" ]; then
    cp ${PREFIX}/bin/env_build.sh ${PREFIX}/bin/env_build.sh.bak
fi
cp env_build.sh ${PREFIX}/bin

echo "# source file of the fenics-${TAG} environment
# source this file, then run  pew workon fenics-${TAG}

module load Python/3.6.4-intel-2018a
module load CMake/3.11.1-GCCcore-6.4.0
module load Boost/1.66.0-intel-2018a-Python-3.6.4
module load Bison/3.0.4-GCCcore-6.4.0
module load flex/2.6.4-GCCcore-6.4.0
module load HDF5/1.10.1-intel-2018a
module load Doxygen/1.8.12-GCCcore-6.4.0
# module load SWIG/3.0.12-intel-2018a-Python-3.6.4
module load Eigen/3.3.4
module load Szip/2.1.1-GCCcore-6.4.0
module load MPFR/4.0.1-GCCcore-6.4.0

export CC=icc
export CXX=icpc
export FC=ifort
# export F77=gfortran
# export F90=gfortran

export MPICC=mpiicc
export MPICXX=mpiicpc
export MPIF77=mpiifort
export MPIF90=mpiifort
export MPIEXEC=mpiexec

export I_MPI_CXX=icpc
export I_MPI_CC=icc
export I_MPI_FC=ifort

export I_MPI_PMI_LIBRARY=/usr/lib64/libpmix.so

export flags=\"-O2 -xCORE-AVX2 -DEIGEN_USE_MKL_ALL\"
export CFLAGS=\"\$flags\"
export FCFLAGS=\"\$flags\"
export CXXFLAGS=\"\$flags\"
export F90FLAGS=\"\$flags\"

export PREFIX=${PREFIX}

# unset PYTHONPATH

export PATH=\${PREFIX}/bin:\${PATH}
export LD_LIBRARY_PATH=\${PREFIX}/lib:\${PREFIX}/lib64:\${LD_LIBRARY_PATH}
export MANPATH=\${PREFIX}/share/man:\${MANPATH}
export PKG_CONFIG_PATH=\${PREFIX}/lib64/pkgconfig:\${PKG_CONFIG_PATH}

export PETSC_DIR=\${PREFIX}
# export SLEPC_DIR=\${PREFIX}

# export INSTANT_CACHE_DIR=\${PREFIX}/cache/instant
# export INSTANT_ERROR_DIR=\${PREFIX}/cache/instant" \
    > ${PREFIX}/bin/env_fenics_run.sh

chmod +x ${PREFIX}/bin/env_fenics_run.sh



echo "
Load FEniCS ${TAG} environment with 
    source ${PREFIX}/bin/env_fenics_run.sh

Load python virtualenv with
    pew workon fenics-${TAG}"
