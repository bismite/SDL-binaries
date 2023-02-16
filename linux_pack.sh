#!/bin/bash

(
cd linux ;
tar -c -h -f SDL.tgz include licenses \
  lib/libSDL2-2.0.so.0 lib/libSDL2_image-2.0.so.0 lib/libSDL2_mixer-2.0.so.0
)
