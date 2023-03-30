#!/bin/bash
## COMMENT THIS SECTION WHEN ./build_all.sh works without errors ##
#
#source env_build.sh
#export FENICS_VERSION="2019.1.0.post0"
#export TAG="${FENICS_VERSION}-intel2018a"
#
## ------------------------------------------------------------- ##
pew new -d  fenics-${TAG} -i ply 


if [ "$continue_on_key" = true ]; then
    echo "Press any key to continue..."
    read -n 1
fi
