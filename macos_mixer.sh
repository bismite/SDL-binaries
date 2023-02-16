#!/bin/bash

SDL_MIXER=SDL2_mixer-2.6.3
PREFIX=$(pwd)/macos
echo ${PREFIX}

# search path
export C_INCLUDE_PATH=${PREFIX}/include
export LIBRARY_PATH=${PREFIX}/lib
export PATH=${PREFIX}/bin:$PATH

DISABLES="--disable-music-mod --disable-music-midi --disable-music-flac --disable-music-opus"

rm -rf /tmp/${SDL_MIXER}
tar zxf ${SDL_MIXER}.tar.gz -C /tmp
(
  cd /tmp/${SDL_MIXER} ;
  ./configure --prefix=${PREFIX} --enable-static=yes ${DISABLES} --disable-sdltest \
    CFLAGS="-O2 -g -arch arm64 -arch x86_64" \
    LDFLAGS="-arch arm64 -arch x86_64 -L${PREFIX}/lib" ;
  make install
)

mkdir -p macos/licenses
cp /tmp/${SDL_MIXER}/LICENSE.txt macos/licenses/${SDL_MIXER}-LICENSE.txt
