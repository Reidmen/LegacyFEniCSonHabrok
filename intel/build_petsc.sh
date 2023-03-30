#!/bin/bash
source env_build.sh

## COMMENT THIS SECTION WHEN ./build_all.sh works without errors ##
# TODO: build PETSc with --download-hypre to get hypre preconditioners
# export FENICS_VERSION="2019.1.0.post0"
# export TAG="${FENICS_VERSION}-intel2018a"

# export BUILD_THREADS=1
# export PREFIX=${HOME}/dev/fenics-${TAG}
# export BUILD_DIR=${HOME}/dev/build/fenics-${TAG}

# mkdir - p ${PREFIX}


# #--------------------------------------------------------------##

#VERSION="3.13.2"
VERSION="3.11.3"

#export CXXFLAGS="${CXXFLAGS} -std=c++0x"

echo "Downloading and building PETSc ${VERSION}"

mkdir -p $BUILD_DIR/tar

# TODO currently onption --download-hypre not available, petsc needs to be updated!
cd ${BUILD_DIR} && \
   wget --quiet --read-timeout=10 -nc -P tar/ http://ftp.mcs.anl.gov/pub/petsc/release-snapshots/petsc-lite-${VERSION}.tar.gz && \
   tar -xzf tar/petsc-lite-${VERSION}.tar.gz && \
   cd petsc-${VERSION} && \
     python2 ./configure \
        --with-cxx=$MPICXX \
        --with-cc=$MPICC \
        --with-fc=$MPIF90 \
        --COPTFLAGS="-03 -xCORE-AVX2" \
        --CXXOPTFLAGS="-O3 -xCORE-AVX2" \
        --FOPTFLAGS="-O3 -xCORE-AVX2" \
        --with-c-support \
        --with-shared-libraries \
        --with-debugging=0 \
        --with-blaslapack-dir=${MKLROOT} \
        --download-mumps \
	    --download-scalapack \
	    --download-parmetis \
    	--download-metis \
        --download-ptscotch \
        --download-blacs \
        --download-suitesparse \
        --prefix=${PREFIX} && \
     make MAKE_NP=${BUILD_THREADS} && make install 

if [ "$continue_on_key" = true ]; then
    echo "Press any key to continue..."
    read -n 1
fi
