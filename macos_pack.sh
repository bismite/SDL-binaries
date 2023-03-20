#!/bin/bash
set -e
ARCH=$1
PREFIX="$(pwd)/macos-${ARCH}"
LIBSDL=libSDL2-2.0.0.dylib
LIBSDL_IMAGE=libSDL2_image-2.0.3.0.0.dylib
LIBSDL_MIXER=libSDL2_mixer-2.0.3.0.0.dylib

# update install name
install_name_tool -change ${PREFIX}/lib/${LIBSDL} @rpath/${LIBSDL} ${PREFIX}/lib/${LIBSDL_IMAGE}
install_name_tool -change ${PREFIX}/lib/${LIBSDL} @rpath/${LIBSDL} ${PREFIX}/lib/${LIBSDL_MIXER}
install_name_tool -id @rpath/${LIBSDL} ${PREFIX}/lib/${LIBSDL}
install_name_tool -id @rpath/${LIBSDL_IMAGE} ${PREFIX}/lib/${LIBSDL_IMAGE}
install_name_tool -id @rpath/${LIBSDL_MIXER} ${PREFIX}/lib/${LIBSDL_MIXER}

(
  cd ${PREFIX} ;
  tar --create -f SDL.tgz \
    licenses include \
    lib/libSDL2.dylib lib/libSDL2.a \
    lib/libSDL2_image.dylib lib/libSDL2_image.a \
    lib/libSDL2_mixer.dylib lib/libSDL2_mixer.a
  tar --append -f SDL.tgz -H lib/${LIBSDL} lib/${LIBSDL_IMAGE} lib/${LIBSDL_MIXER}
)
