#!/bin/bash
set -e
SDL="SDL2-2.30.3"
SRC_DIR="/tmp/${SDL}"
BUILD_DIR="tmp/build/emscripten/${SDL}"
PREFIX="$(pwd)/tmp/emscripten"
echo PREFIX=${PREFIX}

rm -rf ${SRC_DIR}
rm -rf ${BUILD_DIR}
tar xf ${SDL}.tar.gz -C /tmp/
emcmake cmake -B ${BUILD_DIR} ${SRC_DIR} \
  -DCMAKE_INSTALL_PREFIX=${PREFIX} \
  -DSDL_STATIC_PIC=ON \
  -DCMAKE_BUILD_TYPE=Release \
  -DSDL_TEST=OFF -DSDL_TESTS=OFF -DSDL_INSTALL_TESTS=OFF
(
  cd ${BUILD_DIR}
  emmake make
  emmake make install
)
# remove test header
rm ${PREFIX}/include/SDL2/SDL_test*.h

mkdir -p ${PREFIX}/licenses
cp ${SRC_DIR}/LICENSE.txt ${PREFIX}/licenses/${SDL}-LICENSE.txt
