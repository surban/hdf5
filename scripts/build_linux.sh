#!/bin/bash

set -e

cd $(dirname "${BASH_SOURCE[0]}")
cd ..

mkdir -p build_linux
cd build_linux
cmake -DHDF5_BUILD_EXAMPLES:BOOL=OFF -DBUILD_TESTING:BOOL=OFF -DHDF5_BUILD_CPP_LIB:BOOL=OFF -DHDF5_ENABLE_Z_LIB_SUPPORT:BOOL=ON  ..
make -j
cd ..

