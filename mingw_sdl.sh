#!/bin/bash
SDL=SDL2-2.26.3
PREFIX=$(pwd)/mingw

rm -rf /tmp/${SDL}
tar xf ${SDL}.tar.gz -C /tmp

(
  cd /tmp/${SDL} ;
  ./configure --prefix=${PREFIX} --host=x86_64-w64-mingw32
  make install
  mkdir -p ${PREFIX}/licenses
  cp LICENSE.txt ${PREFIX}/licenses/${SDL}-LICENSE.txt
)
