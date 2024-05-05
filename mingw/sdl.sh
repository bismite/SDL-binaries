#!/bin/bash

SDL_VERSION="2.30.3"
PREFIX=$(pwd)/tmp/mingw

mkdir -p ${PREFIX}
tar -C ${PREFIX} --strip-components=2 -x -f SDL2-devel-${SDL_VERSION}-mingw.tar.gz SDL2-${SDL_VERSION}/x86_64-w64-mingw32
tar -C ${PREFIX} --strip-components=1 -x -f SDL2-${SDL_VERSION}.tar.gz SDL2-${SDL_VERSION}/LICENSE.txt

mkdir -p ${PREFIX}/licenses
mv ${PREFIX}/LICENSE.txt ${PREFIX}/licenses/SDL-${SDL_VERSION}-LICENSE.txt
