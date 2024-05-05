#!/bin/bash
set -e

PREFIX="$(pwd)/tmp/macos"
LIBSDL=libSDL2.dylib
LIBSDL_IMAGE=libSDL2_image.dylib
LIBSDL_MIXER=libSDL2_mixer.dylib

(
  cd ${PREFIX} ;
  tar --create -f SDL.tgz \
    bin licenses include \
    lib/libSDL2.dylib lib/libSDL2.a \
    lib/libSDL2_image.dylib lib/libSDL2_image.a \
    lib/libSDL2_mixer.dylib lib/libSDL2_mixer.a
)
