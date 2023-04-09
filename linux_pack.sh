#!/bin/bash

(
cd linux ;
patchelf --set-soname libSDL2.so       lib/libSDL2.so ;
patchelf --set-soname libSDL2_image.so lib/libSDL2_image.so ;
patchelf --set-soname libSDL2_mixer.so lib/libSDL2_mixer.so ;
tar -c -h -f SDL.tgz include licenses \
  lib/libSDL2.so lib/libSDL2_image.so lib/libSDL2_mixer.so \
  lib/libSDL2.a lib/libSDL2main.a lib/libSDL2_image.a lib/libSDL2_mixer.a ;
)
