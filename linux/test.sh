#!/bin/bash
set -e
PREFIX="$(pwd)/tmp/linux"
cp -R assets ${PREFIX}/

# shared
clang -Wall -std=c11 -O3 test.c -o ${PREFIX}/test \
  -L${PREFIX}/lib -I${PREFIX}/include \
  -lSDL2 -lSDL2_image -lSDL2_mixer \
  -lGL -Wl,-rpath=\$ORIGIN/lib

# static
clang -Wall -std=c11 -O3 -flto test.c -o ${PREFIX}/test-static \
  -D_THREAD_SAFE \
  -L${PREFIX}/lib -I${PREFIX}/include \
  ${PREFIX}/lib/libSDL2.a ${PREFIX}/lib/libSDL2_image.a ${PREFIX}/lib/libSDL2_mixer.a \
  -pthread -lm -lGL
