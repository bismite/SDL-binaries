#!/bin/bash

mkdir -p macos
cp -R assets macos
clang -Wall -std=c11 -O3 test.c -o macos/test \
  -Lmacos/lib -Imacos/include \
  -lSDL2 -lSDL2_image -lSDL2_mixer \
  -framework OpenGL
install_name_tool -add_rpath @executable_path/lib macos/test
cp macos/lib/libSDL2-2.0.0.dylib macos/
cp macos/lib/libSDL2_image-2.0.0.dylib macos/
cp macos/lib/libSDL2_mixer-2.0.0.dylib macos/
