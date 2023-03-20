#!/bin/bash
set -e
SDL_MIXER=SDL2_mixer-2.6.3
ARCH=$1
PREFIX="$(pwd)/macos-${ARCH}"
export PATH=${PREFIX}/bin:$PATH
echo ${PREFIX}

rm -rf /tmp/${SDL_MIXER}
rm -rf ${PREFIX}/sdl_mixer
tar zxf ${SDL_MIXER}.tar.gz -C /tmp

for i in  ON OFF
do
  cmake -B ${PREFIX}/sdl_mixer /tmp/${SDL_MIXER}/ \
    -DBUILD_SHARED_LIBS=${i} \
    -DCMAKE_OSX_ARCHITECTURES="${ARCH}" \
    -DCMAKE_BUILD_TYPE=Release -DCMAKE_POSITION_INDEPENDENT_CODE=ON \
    -DCMAKE_PREFIX_PATH=${PREFIX} -DSDL2_DIR=${PREFIX} \
    -DSDL2MIXER_FLAC=OFF -DSDL2MIXER_MOD=OFF -DSDL2MIXER_MIDI=OFF \
    -DSDL2MIXER_OPUS=OFF -DSDL2MIXER_MP3_DRMP3=ON -DSDL2MIXER_VORBIS_STB=ON
  cmake --build ${PREFIX}/sdl_mixer --config Release --parallel
  cmake --install ${PREFIX}/sdl_mixer --prefix ${PREFIX}
done

mkdir -p ${PREFIX}/licenses
cp /tmp/${SDL_MIXER}/LICENSE.txt ${PREFIX}/licenses/${SDL_MIXER}-LICENSE.txt
