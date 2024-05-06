#!/bin/bash
set -e
PREFIX="$(pwd)/tmp/macos"
(
  cd ${PREFIX} ;
  tar -czf SDL.tgz \
    bin licenses include \
    lib/libSDL2.dylib lib/libSDL2.a \
    lib/libSDL2_image.dylib lib/libSDL2_image.a \
    lib/libSDL2_mixer.dylib lib/libSDL2_mixer.a
)
