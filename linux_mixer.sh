#!/bin/bash

SDL_MIXER="SDL2_mixer-2.6.3"

export PATH=$(pwd)/linux/bin:$PATH
mkdir -p linux/sdl_mixer
rm -rf /tmp/${SDL_MIXER}
tar xf ${SDL_MIXER}.tar.gz -C /tmp

cmake -B linux/sdl_mixer /tmp/${SDL_MIXER} -DCMAKE_PREFIX_PATH=linux \
  -DSDL2MIXER_FLAC=OFF -DSDL2MIXER_MOD=OFF -DSDL2MIXER_MIDI=OFF \
  -DSDL2MIXER_OPUS=OFF -DSDL2MIXER_MP3_DRMP3=ON -DSDL2MIXER_VORBIS_STB=ON
cmake --build linux/sdl_mixer --parallel
cmake --install linux/sdl_mixer --prefix linux

mkdir -p linux/licenses
cp /tmp/${SDL_MIXER}/LICENSE.txt linux/licenses/${SDL_MIXER}-LICENSE.txt
