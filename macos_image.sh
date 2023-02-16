#!/bin/bash

SDL_IMAGE=SDL2_image-2.6.3
PREFIX=$(pwd)/macos
echo ${PREFIX}

export PATH=$PATH:${PREFIX}/bin

rm -rf /tmp/${SDL_IMAGE}
tar zxf ${SDL_IMAGE}.tar.gz -C /tmp
(
  cd /tmp/${SDL_IMAGE} ;
  ./configure --prefix=${PREFIX} --enable-static=yes \
    CFLAGS="-O2 -g -arch arm64 -arch x86_64" \
    LDFLAGS="-arch arm64 -arch x86_64" ;
  make install
)

mkdir -p macos/licenses
cp /tmp/${SDL_IMAGE}/LICENSE.txt build/licenses/${SDL_IMAGE}-LICENSE.txt
