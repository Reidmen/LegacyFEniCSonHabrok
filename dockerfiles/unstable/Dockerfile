# Author: Reidmen

FROM reidmen/failure-attempt-fenics:latest
MAINTAINER reidmen <r.a.arostica.barrera@rug.nl>

USER root 

ENV FENICS_PYTHON=python3
ENV DOLFIN_VERSION="2019.1.0.post0"
ENV MSHR_VERSION="2019.1.0"
ENV PYPI_FENICS_VERSION=">=2019.1.0,<2019.2.0"

WORKDIR /tmp
RUN /bin/bash -c "PIP_NO_CACHE_DIR=off ${FENICS_PYTHON} -m pip install 'fenics${PYPI_FENICS_VERSION}' && \
                  git clone https://bitbucket.org/fenics-project/dolfin.git && \
                  cd dolfin && \
                  git checkout ${DOLFIN_VERSION} && \
                  mkdir build && \
                  cd build && \
                  cmake ../ && \
                  make && \
                  make install && \
                  mv /usr/local/share/dolfin/demo /tmp/demo && \
                  mkdir -p /usr/local/share/dolfin/demo && \
                  mv /tmp/demo /usr/local/share/dolfin/demo/cpp && \
                  cd ../python && \
                  PIP_NO_CACHE_DIR=off ${FENICS_PYTHON} -m pip install . && \
                  cd demo && \
                  python3 generate-demo-files.py && \
                  mkdir -p /usr/local/share/dolfin/demo/python && \
                  cp -r documented /usr/local/share/dolfin/demo/python && \
                  cp -r undocumented /usr/local/share/dolfin/demo/python && \
                  cd /tmp/ && \
                  git clone https://bitbucket.org/fenics-project/mshr.git && \
                  cd mshr && \
                  git checkout ${MSHR_VERSION} && \
                  mkdir build && \
                  cd build && \
                  cmake ../ && \
                  make && \
                  make install && \
                  cd ../python && \
                  PIP_NO_CACHE_DIR=off ${FENICS_PYTHON} -m pip install . && \
                  ldconfig && \
                  rm -rf /tmp/*"
# the user does not need them in the stable image!
RUN /bin/bash -c "cp -r /usr/local/share/dolfin/demo $FENICS_HOME/demo && \
                  rm -rf /home/fenics/local && \
                  rm -rf $FENICS_HOME/bin && \
                  echo '' >> $FENICS_HOME/.profile" 
USER fenics
WORKDIR $FENICS_HOME
# TODO: run unit tests 
#RUN /bin/bash -l -c "export MPLBACKEND=Agg && \
#    mkdir -p /tmp/poisson_test && \
#    cd /tmp/poisson_test && \
#    python3 $FENICS_HOME/demo/python/documented/poisson/demo_poisson.py && \
#    rm -r /tmp/poisson_test"
COPY WELCOME $FENICS_HOME/WELCOME
USER root

