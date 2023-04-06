#!/bin/bash

SDL="SDL2-2.26.5"
mkdir -p linux/sdl
rm -rf /tmp/${SDL}
tar xf ${SDL}.tar.gz -C /tmp

cmake -B linux/sdl /tmp/${SDL}/ -DCMAKE_PREFIX_PATH=linux
cmake --build linux/sdl --parallel
cmake --install linux/sdl --prefix linux

mkdir -p linux/licenses
cp /tmp/${SDL}/LICENSE.txt linux/licenses/${SDL}-LICENSE.txt
