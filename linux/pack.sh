#!/bin/bash
PREFIX="$(pwd)/tmp/linux"
(
  cd ${PREFIX}
  tar --create -f SDL.tgz \
    bin licenses include \
    lib/libSDL2.so lib/libSDL2.a lib/libSDL2main.a \
    lib/libSDL2_image.so lib/libSDL2_image.a \
    lib/libSDL2_mixer.so lib/libSDL2_mixer.a
)
