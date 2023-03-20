#!/bin/bash
set -e
ARCH=$1
PREFIX="$(pwd)/macos-${ARCH}"

mkdir -p ${PREFIX}
cp -R assets ${PREFIX}
clang -Wall -std=c11 -O3 test.c -o ${PREFIX}/test \
  -L ${PREFIX}/lib -I ${PREFIX}/include \
  -lSDL2 -lSDL2_image -lSDL2_mixer \
  -framework OpenGL -arch ${ARCH}

install_name_tool -add_rpath @executable_path/lib ${PREFIX}/test
