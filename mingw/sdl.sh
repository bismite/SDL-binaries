#!/bin/bash
set -e
VERSION=$1
SDL="SDL2-${VERSION}"
PREFIX=$(pwd)/tmp/mingw

mkdir -p ${PREFIX}
tar -C ${PREFIX} --strip-components=2 -x -f SDL2-devel-${VERSION}-mingw.tar.gz ${SDL}/x86_64-w64-mingw32
tar -C ${PREFIX} --strip-components=1 -x -f ${SDL}.tar.gz ${SDL}/LICENSE.txt

mkdir -p ${PREFIX}/licenses
mv ${PREFIX}/LICENSE.txt ${PREFIX}/licenses/${SDL}-LICENSE.txt
