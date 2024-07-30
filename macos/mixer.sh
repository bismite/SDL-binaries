#!/bin/bash
set -e
VERSION=$1
SDL_MIXER=SDL2_mixer-${VERSION}
SRC_DIR="/tmp/${SDL_MIXER}"
BUILD_DIR="tmp/build/macos/${SDL_MIXER}"
PREFIX="$(pwd)/tmp/macos"
export PATH=${PREFIX}/bin:$PATH
echo ${PREFIX}

rm -rf ${SRC_DIR}
rm -rf ${BUILD_DIR}
tar xf ${SDL_MIXER}.tar.gz -C /tmp
for SHARED in ON OFF ; do
  cmake -B ${BUILD_DIR} ${SRC_DIR} \
    -DBUILD_SHARED_LIBS=${SHARED} \
    -DCMAKE_OSX_ARCHITECTURES=arm64 \
    -DCMAKE_BUILD_TYPE=Release -DCMAKE_POSITION_INDEPENDENT_CODE=ON \
    -DCMAKE_PREFIX_PATH=${PREFIX} -DSDL2_DIR=${PREFIX} \
    -DSDL2MIXER_WAVPACK=OFF \
    -DSDL2MIXER_FLAC=OFF -DSDL2MIXER_MOD=OFF -DSDL2MIXER_MIDI=OFF \
    -DSDL2MIXER_OPUS=OFF -DSDL2MIXER_MP3_MINIMP3=ON -DSDL2MIXER_VORBIS_STB=ON
  cmake --build ${BUILD_DIR} --config Release --parallel -- VERBOSE=1
  cmake --install ${BUILD_DIR} --prefix ${PREFIX}
done
# rename
(
  cd ${PREFIX}/lib
  install_name_tool -id @rpath/libSDL2_mixer.dylib libSDL2_mixer.dylib
  mv -f $(readlink -f libSDL2_mixer.dylib) libSDL2_mixer.dylib
  rm libSDL2_mixer-2.*.dylib
)

mkdir -p ${PREFIX}/licenses
cp ${SRC_DIR}/LICENSE.txt ${PREFIX}/licenses/${SDL_MIXER}-LICENSE.txt
