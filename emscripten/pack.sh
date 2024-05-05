#!/bin/bash

(
cd tmp/emscripten ;
tar -c -f SDL.tgz include licenses \
  lib/libSDL2.a lib/libSDL2_image.a lib/libSDL2_mixer.a
)
