#!/bin/bash

PREFIX=$(pwd)/macos

# update install name
install_name_tool -change ${PREFIX}/lib/libSDL2-2.0.0.dylib @rpath/libSDL2-2.0.0.dylib ${PREFIX}/lib/libSDL2_image-2.0.0.dylib
install_name_tool -change ${PREFIX}/lib/libSDL2-2.0.0.dylib @rpath/libSDL2-2.0.0.dylib ${PREFIX}/lib/libSDL2_mixer-2.0.0.dylib
install_name_tool -id @rpath/libSDL2-2.0.0.dylib ${PREFIX}/lib/libSDL2-2.0.0.dylib
install_name_tool -id @rpath/libSDL2_image-2.0.0.dylib ${PREFIX}/lib/libSDL2_image-2.0.0.dylib
install_name_tool -id @rpath/libSDL2_mixer-2.0.0.dylib ${PREFIX}/lib/libSDL2_mixer-2.0.0.dylib

(
  cd macos ;
  tar -c -f SDL.tgz include \
    lib/libSDL2-2.0.0.dylib lib/libSDL2.dylib lib/libSDL2.a \
    lib/libSDL2_image-2.0.0.dylib lib/libSDL2_image.dylib lib/libSDL2_image.a \
    lib/libSDL2_mixer-2.0.0.dylib lib/libSDL2_mixer.dylib lib/libSDL2_mixer.a \
    licenses
)
