#!/bin/bash

mkdir -p linux/sdl
rm -rf linux/SDL2-2.26.3
tar xf SDL2-2.26.3.tar.gz -C linux

cmake -B linux/sdl build/SDL2-2.26.3/ -DCMAKE_PREFIX_PATH=linux
cmake --build linux/sdl --parallel
cmake --install linux/sdl --prefix linux
