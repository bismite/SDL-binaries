#!/bin/bash
set -e
SDL="SDL2-2.30.3"
SRC_DIR="/tmp/${SDL}"
BUILD_DIR="tmp/build/macos/${SDL}"
PREFIX="$(pwd)/tmp/macos"
echo PREFIX=${PREFIX}

rm -rf ${SRC_DIR}
rm -rf ${BUILD_DIR}
tar xf ${SDL}.tar.gz -C /tmp/
cmake -B ${BUILD_DIR} ${SRC_DIR} \
  -DCMAKE_OSX_ARCHITECTURES=arm64 \
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
  install_name_tool -id @rpath/libSDL2.dylib libSDL2.dylib
  mv -f $(readlink -f libSDL2.dylib) libSDL2.dylib
  rm libSDL2-2.*.dylib
  ln -s libSDL2.dylib libSDL2-2.0.0.dylib
)

mkdir -p ${PREFIX}/licenses
cp ${SRC_DIR}/LICENSE.txt ${PREFIX}/licenses/${SDL}-LICENSE.txt
