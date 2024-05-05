#!/bin/bash

emcc -Wall -std=c11 -O0 test.c -o tmp/emscripten/test.html \
  -sUSE_SDL=0 -sMAIN_MODULE \
  tmp/emscripten/lib/libSDL2.a tmp/emscripten/lib/libSDL2_image.a tmp/emscripten/lib/libSDL2_mixer.a \
  -Itmp/emscripten/include \
  -sMAX_WEBGL_VERSION=2 \
  -sWASM=1 -sALLOW_MEMORY_GROWTH=1 --preload-file assets@assets
