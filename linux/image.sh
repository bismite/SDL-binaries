#!/bin/bash
set -e
SDL_IMAGE=SDL2_image-2.8.2
SRC_DIR="/tmp/${SDL_IMAGE}"
BUILD_DIR="tmp/build/linux/${SDL_IMAGE}"
PREFIX="$(pwd)/tmp/linux"
export PATH=${PREFIX}/bin:$PATH
echo PREFIX=${PREFIX}

rm -rf ${SRC_DIR}
rm -rf ${BUILD_DIR}
tar xf ${SDL_IMAGE}.tar.gz -C /tmp/
for SHARED in ON OFF ; do
  cmake -B ${BUILD_DIR} ${SRC_DIR} \
    -DBUILD_SHARED_LIBS=${SHARED} \
    -DCMAKE_POSITION_INDEPENDENT_CODE=ON \
    -DCMAKE_BUILD_TYPE=Release -DSDL2IMAGE_SAMPLES=OFF -DSDL2IMAGE_TESTS_INSTALL=OFF -DSDL2IMAGE_VENDORED=OFF \
    -DCMAKE_PREFIX_PATH=${PREFIX} -DSDL2_DIR=${PREFIX} \
    -DSDL2IMAGE_BACKEND_STB=ON -DSDL2IMAGE_PNG=ON -DSDL2IMAGE_JPG=ON \
    -DSDL2IMAGE_AVIF=OFF -DSDL2IMAGE_BMP=OFF -DSDL2IMAGE_GIF=OFF \
    -DSDL2IMAGE_JXL=OFF  -DSDL2IMAGE_LBM=OFF -DSDL2IMAGE_PCX=OFF \
    -DSDL2IMAGE_PNM=OFF  -DSDL2IMAGE_QOI=OFF -DSDL2IMAGE_SVG=OFF \
    -DSDL2IMAGE_TGA=OFF  -DSDL2IMAGE_TIF=OFF -DSDL2IMAGE_WEBP=OFF \
    -DSDL2IMAGE_XCF=OFF  -DSDL2IMAGE_XPM=OFF -DSDL2IMAGE_XV=OFF
  cmake --build ${BUILD_DIR} --config Release --parallel -- VERBOSE=1
  cmake --install ${BUILD_DIR} --prefix ${PREFIX}
done

# rename
(
  cd ${PREFIX}/lib
  patchelf --set-soname libSDL2_image.so libSDL2_image.so
  SONAME=$(readlink -f libSDL2_image.so)
  mv -f ${SONAME} libSDL2_image.so
  rm libSDL2_image-*
  ln -s libSDL2_image.so ${SONAME}
)

mkdir -p ${PREFIX}/licenses
cp ${SRC_DIR}/LICENSE.txt ${PREFIX}/licenses/${SDL_IMAGE}-LICENSE.txt
