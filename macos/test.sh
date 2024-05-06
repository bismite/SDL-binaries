#!/bin/bash
set -e
PREFIX="$(pwd)/tmp/test/macos"
mkdir -p ${PREFIX}
cp -R assets ${PREFIX}/
tar xf tmp/macos/SDL.tgz -C ${PREFIX}

# shared
clang -Wall -std=c11 -O3 test.c -o ${PREFIX}/test \
  -L${PREFIX}/lib -I${PREFIX}/include \
  -lSDL2 -lSDL2_image -lSDL2_mixer \
  -framework OpenGL -arch arm64

install_name_tool -add_rpath @executable_path/lib ${PREFIX}/test

# static
clang -Wall -std=c11 -O3 -flto test.c -o ${PREFIX}/test-static \
  -D_THREAD_SAFE \
  -L${PREFIX}/lib -I${PREFIX}/include \
  ${PREFIX}/lib/libSDL2.a ${PREFIX}/lib/libSDL2_image.a ${PREFIX}/lib/libSDL2_mixer.a \
  -framework OpenGL -arch arm64 \
  -Wl,-framework,CoreVideo -Wl,-framework,Cocoa -Wl,-framework,IOKit \
  -Wl,-framework,ForceFeedback -Wl,-framework,Carbon -Wl,-framework,CoreAudio \
  -Wl,-framework,AudioToolbox -Wl,-framework,AVFoundation -Wl,-framework,Foundation \
  -Wl,-weak_framework,GameController -Wl,-weak_framework,Metal -Wl,-weak_framework,QuartzCore \
  -Wl,-weak_framework,CoreHaptics -lm -liconv
strip ${PREFIX}/test-static
