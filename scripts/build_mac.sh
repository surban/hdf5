#!/bin/bash

set -e

cd $(dirname "${BASH_SOURCE[0]}")
cd ..

mkdir -p build_mac
cd build_mac
cmake -DCMAKE_BUILD_TYPE=RelWithDebInfo -DHDF5_BUILD_EXAMPLES:BOOL=OFF -DBUILD_TESTING:BOOL=OFF -DHDF5_BUILD_CPP_LIB:BOOL=OFF -DHDF5_ENABLE_Z_LIB_SUPPORT:BOOL=ON -DHDF5_ENABLE_THREADSAFE:BOOL=ON ..
make 
cd ..

mkdir mac
cp build_mac/bin/libhdf5.dylib build_mac/bin/libhdf5_hl.dylib mac/
zip hdf5_mac.zip mac/*
