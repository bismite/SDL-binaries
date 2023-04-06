#!/bin/bash
set -e
SDL="SDL2-2.26.5"
ARCH=$1
PREFIX="$(pwd)/macos-${ARCH}"
echo ${PREFIX}

rm -rf /tmp/${SDL}
rm -rf ${PREFIX}/sdl
tar xf ${SDL}.tar.gz -C /tmp
cmake -B ${PREFIX}/sdl /tmp/${SDL}/ \
  -DCMAKE_PREFIX_PATH=macos-${ARCH} \
  -DCMAKE_OSX_ARCHITECTURES="${ARCH}" \
  -DSDL_TESTS=OFF \
  -DSDL_INSTALL_TESTS=OFF \
  -DCMAKE_BUILD_TYPE=Release
cmake --build ${PREFIX}/sdl --config Release --parallel
cmake --install ${PREFIX}/sdl --prefix ${PREFIX}

rm ${PREFIX}/include/SDL2/SDL_test*.h
(
  cd ${PREFIX}/lib
  rm libSDL2.dylib
  ln -s libSDL2-2.0.0.dylib libSDL2.dylib
)

mkdir -p ${PREFIX}/licenses
cp /tmp/${SDL}/LICENSE.txt ${PREFIX}/licenses/${SDL}-LICENSE.txt
