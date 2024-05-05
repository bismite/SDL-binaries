#!/bin/bash

(
  cd mingw ;
  tar -c -f SDL.tgz include \
    lib/libSDL2.a lib/libSDL2main.a lib/libSDL2_image.a lib/libSDL2_mixer.a \
    bin/SDL2.dll bin/SDL2_image.dll bin/SDL2_mixer.dll \
    licenses
)

