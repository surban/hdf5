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
cmake -DCMAKE_BUILD_TYPE=RelWithDebInfo -DHDF5_BUILD_EXAMPLES:BOOL=OFF -DBUILD_TESTING:BOOL=OFF -DHDF5_BUILD_CPP_LIB:BOOL=OFF -DHDF5_ENABLE_Z_LIB_SUPPORT:BOOL=ON  ..
make -j
cd bin
rm -f libhdf5.so libhdf5_hl.so
rm -f libhdf5.so.101 libhdf5_hl.so.101
mv libhdf5.so.100.2.0 libhdf5.so.101
mv libhdf5_hl.so.100.2.0 libhdf5_hl.so.101
genstub hdf5 libhdf5.so.101 true
genstub hdf5_hl "libhdf5.so.101 libhdf5_hl.so.101" true
cd ../..

mkdir linux64
mv build_linux/bin/libhdf5.so build_linux/bin/libhdf5.so.101 build_linux/bin/libhdf5_hl.so build_linux/bin/libhdf5_hl.so.101 linux64/
zip hdf5_linux.zip linux64/*
