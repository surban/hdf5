#!/bin/bash

set -e

genstub () 
{
    DLLNAME=$1
    TARGETS=$2
    LOCAL=$3

    if [ "$LOCAL" = "true" ]; then
        RPATH='-Wl,-rpath=$ORIGIN'
    else
        RPATH=''
    fi

    LIBARG=""
    for TARGET in $TARGETS ; do
        LIBARG="$LIBARG -l:${TARGET}"
    done
    gcc -Wl,--no-as-needed $RPATH -shared -o lib${DLLNAME}.so -fPIC -L. $LIBARG

    echo "Mapped ${DLLNAME}.dll ==> ${TARGETS}"
}


cd $(dirname "${BASH_SOURCE[0]}")
cd ..

mkdir -p build_linux
cd build_linux
cmake -DCMAKE_BUILD_TYPE=RelWithDebInfo -DHDF5_BUILD_EXAMPLES:BOOL=OFF -DBUILD_TESTING:BOOL=OFF -DHDF5_BUILD_CPP_LIB:BOOL=OFF -DHDF5_ENABLE_Z_LIB_SUPPORT:BOOL=ON -DHDF5_ENABLE_THREADSAFE:BOOL=ON ..
make -j
cd bin
rm -f libhdf5.so libhdf5_hl.so
rm -f libhdf5.so.103 libhdf5_hl.so.100
mv libhdf5.so.103.1.0 libhdf5.so.103
mv libhdf5_hl.so.100.1.2 libhdf5_hl.so.100
genstub hdf5 libhdf5.so.103 true
genstub hdf5_hl "libhdf5.so.103 libhdf5_hl.so.100" true
cd ../..

mkdir linux64
mv build_linux/bin/libhdf5.so build_linux/bin/libhdf5.so.103 build_linux/bin/libhdf5_hl.so build_linux/bin/libhdf5_hl.so.100 linux64/
zip hdf5_linux.zip linux64/*
