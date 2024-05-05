#!/bin/bash

SDL="SDL2-2.30.3"
SRC_DIR="/tmp/${SDL}"
BUILD_DIR="tmp/build/linux/${SDL}"
PREFIX="$(pwd)/tmp/linux"
echo PREFIX=${PREFIX}

rm -rf ${SRC_DIR}
rm -rf ${BUILD_DIR}
tar xf ${SDL}.tar.gz -C /tmp/

cmake -B tmp/build/linux/${SDL} /tmp/${SDL}/ -DCMAKE_PREFIX_PATH=tmp/linux
cmake -B ${BUILD_DIR} ${SRC_DIR} \
  -DCMAKE_BUILD_TYPE=Release \
  -DSDL_STATIC=ON \
  -DSDL_TEST=OFF -DSDL_TESTS=OFF -DSDL_INSTALL_TESTS=OFF
cmake --build ${BUILD_DIR} --config Release --parallel -- VERBOSE=1
cmake --install ${BUILD_DIR} --prefix ${PREFIX}

# remove test header
rm ${PREFIX}/include/SDL2/SDL_test*.h
# rename
(
  cd ${PREFIX}/lib
  patchelf --set-soname libSDL2.so libSDL2.so
  SONAME=$(readlink -f libSDL2.so)
  mv -f ${SONAME} libSDL2.so
  rm libSDL2-*
  ln -s libSDL2.so ${SONAME}
)

# license
mkdir -p linux/licenses
cp /tmp/${SDL}/LICENSE.txt linux/licenses/${SDL}-LICENSE.txt
