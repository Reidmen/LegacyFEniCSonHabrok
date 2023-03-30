#!/bin/bash
source env_build.sh

SWIG_VERSION="3.0.12"

echo "Downloading and building SWIG ${SWIG_VERSION}"

mkdir -p ${BUILD_DIR}/tar

cd ${BUILD_DIR} && \
    wget --quiet --read-timeout=10 -nc https://github.com/swig/swig/archive/rel-${SWIG_VERSION}.tar.gz -O tar/swig-rel-${SWIG_VERSION}.tar.gz && \
    tar -xf tar/swig-rel-${SWIG_VERSION}.tar.gz && \
    cd swig-rel-${SWIG_VERSION} && \
    ./autogen.sh && \
    ./configure --prefix=${PREFIX} && \
    make -j ${BUILD_THREADS}  && \
    make install

        # --with-pcre-prefix=${PREFIX} \

if [ "$continue_on_key" = true ]; then
    echo "Press any key to continue..."
    read -n 1
fi
