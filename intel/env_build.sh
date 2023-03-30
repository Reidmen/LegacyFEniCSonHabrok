# source this in your shell

echo "setting build environment"

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

export flags="-O2 -xCORE-AVX2 -DEIGEN_USE_MKL_ALL"
export CFLAGS="$flags"
export FCFLAGS="$flags"
export CXXFLAGS="$flags"
export F90FLAGS="$flags"

# unset PYTHONPATH

if [ ! -z "${PREFIX}" ]; then
    export PATH=${PREFIX}/bin:${PATH}
    export LD_LIBRARY_PATH=${PREFIX}/lib:${PREFIX}/lib64:${LD_LIBRARY_PATH}
    export INCLUDE_PATH=${PREFIX}/include:${INCLUDE_PATH}
#    export PYTHONPATH=${PREFIX}/lib/python${PYTHON_VERSION}/site-packages:${PYTHONPATH}
fi
