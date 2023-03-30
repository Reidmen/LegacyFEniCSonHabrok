#!/bin/bash
source env_build.sh

### COMMENT THIS SECTION WHENEVER ./build all |& tee -a build.log works ###
# it requires the directory ${PREFIX}
# exit on error
# set -e 
# FEniCS version
# export FENICS_VERSION="2019.1.0.post0"
# export PKG_VERSION="2019.1.0"

# TAG that specificies the name of the build directories and the virtualenv
# export TAG="${FENICS_VERSION}-intel2018a"

# export PREFIX=${HOME}/dev/fenics-${TAG}
# export BUILD_DIR=${HOME}/dev/build/fenics-${TAG}

# export PYTHON_VERSION="3.6"

### ---------------------------------------------------------------------- ###

mkdir -p $BUILD_DIR/tar

 if [[ $FENICS_VERSION == 2019.1.0.post0 ]]; then
     PYPI_FENICS_VERSION=">=2019.1.0"
     pew in fenics-${TAG} pip3 install fenics-ffc${PYPI_FENICS_VERSION}

 elif [[ $FENICS_VERSION == "master" ]]; then
     for pkg in fiat dijitso ufl ffc; do
         cd $BUILD_DIR
         if [ -d $pkg ]; then
             cd $pkg
             git pull
         else
             git clone https://bitbucket.org/fenics-project/${pkg}.git && \
                 cd $pkg && \
                 git checkout $FENICS_VERSION
             fi
 
         pew in fenics-${TAG} pip3 install --no-deps --upgrade .
 
     done
 
 else
 
     # FIAT
     cd $BUILD_DIR && \
         wget --quiet --read-timeout=10 -nc -P tar https://bitbucket.org/fenics-project/fiat/downloads/fiat-${FENICS_VERSION}.tar.gz && \
         tar -xf tar/fiat-${FENICS_VERSION}.tar.gz && \
         cd fiat-${FENICS_VERSION} && \
         pew in fenics-${TAG} python3 setup.py install
 
     pew in fenics-${TAG} pip install ffc==${FENICS_VERSION} \
         dijitso==${FENICS_VERSION} \
         instant==${FENICS_VERSION} \
         ufl==${FENICS_VERSION}
 
 fi
 
 
 if [ "$continue_on_key" = true ]; then
     echo "Press any key to continue..."
     read -n 1
 fi
 
 
# # UFL
# cd $BUILD_DIR && \
#     wget --quiet --read-timeout=10 -nc -P tar https://bitbucket.org/fenics-project/ufl/downloads/ufl-${PKG_VERSION}.tar.gz && \
#     tar -xf tar/ufl-${PKG_VERSION}.tar.gz && \
#     cd ufl-${PKG_VERSION} && \
#     pew in fenics-${TAG} python setup.py install
#  
# if [ "$continue_on_key" = true ]; then
#     echo "Press any key to continue..."
#     read -n 1
# fi
#  
# # DIJITSO
# cd $BUILD_DIR && \
#    wget --quiet --read-timeout=10 -nc -P tar https://bitbucket.org/fenics-project/dijitso/downloads/dijitso-${PKG_VERSION}.tar.gz && \
#    tar -xf tar/dijitso-${PKG_VERSION}.tar.gz && \
#    cd dijitso-${PKG_VERSION} && \
#    pew in fenics-${TAG} python setup.py install
# 
# if [ "$continue_on_key" = true ]; then
#     echo "Press any key to continue..."
#     read -n 1
# fi
# 
# # FFC
# cd $BUILD_DIR && \
#     wget --quiet --read-timeout=10 -nc -P tar https://bitbucket.org/fenics-project/ffc/downloads/ffc-${PKG_VERSION}.tar.gz && \
#     tar -xf tar/ffc-${PKG_VERSION}.tar.gz && \
#     cd ffc-${PKG_VERSION} && \
#     pew in fenics-${TAG} python setup.py install
# 
# if [ "$continue_on_key" = true ]; then
#     echo "Press any key to continue..."
#     read -n 1
# fi
# 
