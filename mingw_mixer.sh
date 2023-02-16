#!/bin/bash
SDL_MIXER=SDL2_mixer-2.6.3
PREFIX=$(pwd)/mingw
export PATH=${PREFIX}/bin:$PATH
rm -rf /tmp/${SDL_MIXER}
tar xf ${SDL_MIXER}.tar.gz -C /tmp

(
  cd /tmp/${SDL_MIXER} ;
  ./configure --prefix=${PREFIX} --host=x86_64-w64-mingw32 \
    --with-sdl-prefix=${PREFIX} \
    --disable-music-mod --disable-music-midi --disable-music-flac --disable-music-opus \
    --disable-sdltest --disable-music-midi ;
  make install
)

cp "/tmp/${SDL_MIXER}/LICENSE.txt" "${PREFIX}/licenses/${SDL_MIXER}-LICENSE.txt"
