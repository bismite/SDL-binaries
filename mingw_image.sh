#!/bin/bash

SDL_IMAGE=SDL2_image-2.6.3
PREFIX=$(pwd)/mingw
export PATH=${PREFIX}/bin:$PATH
rm -rf /tmp/${SDL_IMAGE}
tar xf ${SDL_IMAGE}.tar.gz -C /tmp

(
  cd /tmp/${SDL_IMAGE}
  ./configure --prefix=${PREFIX} --host=x86_64-w64-mingw32 \
    --with-sdl-prefix=${PREFIX} \
    --disable-avif --disable-jxl --disable-tif --disable-webp \
    --disable-dependency-tracking --disable-sdltest
  make install
)

mkdir -p ${PREFIX}/licenses
cp "/tmp/${SDL_IMAGE}/LICENSE.txt" "${PREFIX}/licenses/${SDL_IMAGE}-LICENSE.txt"
x86_64-w64-mingw32-strip mingw/bin/SDL2_image.dll

