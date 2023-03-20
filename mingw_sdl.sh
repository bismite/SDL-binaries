#!/bin/bash

SDL_VERSION="2.26.4"
PREFIX=$(pwd)/mingw

mkdir -p  mingw
tar -C mingw --strip-components=2 -x -f SDL2-devel-${SDL_VERSION}-mingw.tar.gz SDL2-${SDL_VERSION}/x86_64-w64-mingw32
tar -C mingw --strip-components=1 -x -f SDL2-${SDL_VERSION}.tar.gz SDL2-${SDL_VERSION}/LICENSE.txt
mkdir -p mingw/licenses
mv mingw/LICENSE.txt mingw/licenses/SDL-${SDL_VERSION}-LICENSE.txt
