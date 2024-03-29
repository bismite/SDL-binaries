#!/bin/bash
set -e
SDL_IMAGE="SDL2_image-2.6.3"
export PATH=$(pwd)/linux/bin:$PATH

rm -rf /tmp/${SDL_IMAGE}
tar xf ${SDL_IMAGE}.tar.gz -C /tmp

OPTS=$(echo -DCMAKE_PREFIX_PATH=linux -DSDL2_DIR=linux \
 -DSDL2IMAGE_BACKEND_STB=ON -DSDL2IMAGE_PNG=ON -DSDL2IMAGE_JPG=ON \
 -DSDL2IMAGE_AVIF=OFF -DSDL2IMAGE_BMP=OFF -DSDL2IMAGE_GIF=OFF \
 -DSDL2IMAGE_JXL=OFF  -DSDL2IMAGE_LBM=OFF -DSDL2IMAGE_PCX=OFF \
 -DSDL2IMAGE_PNM=OFF  -DSDL2IMAGE_QOI=OFF -DSDL2IMAGE_SVG=OFF \
 -DSDL2IMAGE_TGA=OFF  -DSDL2IMAGE_TIF=OFF -DSDL2IMAGE_WEBP=OFF \
 -DSDL2IMAGE_XCF=OFF  -DSDL2IMAGE_XPM=OFF -DSDL2IMAGE_XV=OFF )

echo ${OPTS}

cmake -B linux/sdl_image-static /tmp/${SDL_IMAGE} ${OPTS} -DBUILD_SHARED_LIBS=OFF
cmake --build linux/sdl_image-static --parallel
cmake --install linux/sdl_image-static --prefix linux

cmake -B linux/sdl_image /tmp/${SDL_IMAGE} ${OPTS} -DBUILD_SHARED_LIBS=ON
cmake --build linux/sdl_image --parallel
cmake --install linux/sdl_image --prefix linux

mkdir -p linux/licenses
cp /tmp/${SDL_IMAGE}/LICENSE.txt linux/licenses/${SDL_IMAGE}-LICENSE.txt
