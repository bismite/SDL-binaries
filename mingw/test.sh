#!/bin/bash
set -e
PREFIX="$(pwd)/tmp/mingw"
cp -R assets ${PREFIX}/

x86_64-w64-mingw32-gcc -Wall -std=c11 -O3 test.c -o ${PREFIX}/test \
  -L ${PREFIX}/bin -L ${PREFIX}/lib -I ${PREFIX}/include \
  -lmingw32 -lSDL2main -lSDL2 -lSDL2_image -lSDL2_mixer -lopengl32

x86_64-w64-mingw32-gcc -Wall -std=c11 -g0 -O3 -flto test.c -o ${PREFIX}/test-static \
  -L ${PREFIX}/lib -I ${PREFIX}/include \
  -lmingw32 -lopengl32 -lSDL2main \
  ${PREFIX}/lib/libSDL2.a -lSDL2main ${PREFIX}/lib/libSDL2_image.a ${PREFIX}/lib/libSDL2_mixer.a \
  -mwindows -Wl,--dynamicbase -Wl,--nxcompat -Wl,--high-entropy-va -lm \
  -ldinput8 -ldxguid -ldxerr8 -luser32 -lgdi32 -lwinmm -limm32 -lole32 \
  -loleaut32 -lshell32 -lsetupapi -lversion -luuid

x86_64-w64-mingw32-strip ${PREFIX}/test-static.exe
