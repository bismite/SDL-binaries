#!/bin/bash

emcc -Wall -std=c11 -O3 test.c -o em/test.html \
  -flto \
  em/lib/libSDL2.a em/lib/libSDL2_image.a em/lib/libSDL2_mixer.a \
  -Iem/include \
  -sMAX_WEBGL_VERSION=2 \
  -sWASM=1 -sALLOW_MEMORY_GROWTH=1 --preload-file assets@assets \
  -sDEFAULT_LIBRARY_FUNCS_TO_INCLUDE=['$autoResumeAudioContext','$dynCall']
