#!/bin/bash
PREFIX="$(pwd)/tmp/mingw"
(
  cd ${PREFIX}
  tar -czf SDL.tgz \
    bin licenses include \
    lib/libSDL2.a lib/libSDL2main.a lib/libSDL2_image.a lib/libSDL2_mixer.a
)
