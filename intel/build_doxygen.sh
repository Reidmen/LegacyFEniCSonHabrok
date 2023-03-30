#!/bin/bash
source env_build.sh

DOXYGEN_VERSION="1.8.12"
mkdir -p $BUILD_DIR/tar

echo "Downloading and building DOXYGEN ${DOXYGEN_VERSION}"

cd ${BUILD_DIR} && \
   wget --quiet --read-timeout=10 -nc ftp://ftp.stack.nl/pub/users/dimitri/doxygen-${DOXYGEN_VERSION}.src.tar.gz -O tar/doxygen-${DOXYGEN_VERSION}.tar.gz && \
   tar -xf tar/doxygen-${DOXYGEN_VERSION}.tar.gz && \
   cd doxygen-${DOXYGEN_VERSION} && \
   mkdir -p build && \
   cd build && \
   cmake -DCMAKE_INSTALL_PREFIX=${PREFIX} .. && \
   make && make install


if [ "$continue_on_key" = true ]; then
    echo "Press any key to continue..."
    read -n 1
fi
