#!/bin/bash

SDL=SDL2-2.26.3
PREFIX=$(pwd)/macos
echo ${PREFIX}

rm -rf /tmp/${SDL}
tar xf ${SDL}.tar.gz -C /tmp
(
  cd /tmp/${SDL} ;
  ./configure --prefix=${PREFIX} --enable-static=yes \
    CFLAGS="-O2 -g -arch arm64 -arch x86_64" \
    LDFLAGS="-arch arm64 -arch x86_64" ;
  make install
)
rm macos/include/SDL2/SDL_test*.h

mkdir -p macos/licenses
cp /tmp/${SDL}/LICENSE.txt macos/licenses/${SDL}-LICENSE.txt
