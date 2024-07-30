#!/usr/bin/env ruby
require "fileutils"
include FileUtils

VERSION=ARGV[0]
SDL_MIXER="SDL2_mixer-#{VERSION}"
SRC_DIR="/tmp/#{SDL_MIXER}"
BUILD_DIR="tmp/build/emscripten/#{SDL_MIXER}"
PREFIX="#{Dir.pwd}/tmp/emscripten"

SRCS = %w(
  effect_position.c effect_stereoreverse.c effects_internal.c mixer.c music.c utils.c
) + %w(
  load_aiff.c mp3utils.c music_drflac.c music_flac.c music_modplug.c
  music_nativemidi.c music_ogg_stb.c music_timidity.c music_xmp.c load_voc.c
  music_cmd.c music_minimp3.c music_fluidsynth.c music_mpg123.c music_ogg.c
  music_opus.c music_wav.c
).map{|s| "codecs/#{s}" }

def cmd(c)
  puts c
  exit unless system c
end

# clean and extract
rm_rf [BUILD_DIR, SRC_DIR]
mkdir_p SRC_DIR
cmd "tar xf #{SDL_MIXER}.tar.gz -C /tmp/"
# header install
mkdir_p "#{PREFIX}/include/SDL2"
cp "#{SRC_DIR}/include/SDL_mixer.h", "#{PREFIX}/include/SDL2/"
# compile
mkdir_p BUILD_DIR
Dir.chdir(BUILD_DIR){
  (SRCS).each{|s|
    src = "#{SRC_DIR}/src/#{s}"
    include = "-I#{PREFIX}/include/SDL2 -I#{PREFIX}/include -I#{SRC_DIR}/src/codecs -I#{SRC_DIR}/src"
    flags = "-DMUSIC_WAV -DMUSIC_MP3_MINIMP3 -DMUSIC_OGG -DOGG_USE_STB"
    cmd "emcc -Wall -g0 -sSTRICT -flto -O2 -c #{src} -sUSE_SDL=0 #{flags} #{include}"
  }
  cmd "emar cr libSDL2_mixer.a *.o"
}
# lib install
mkdir_p "#{PREFIX}/lib"
cp "#{BUILD_DIR}/libSDL2_mixer.a", "#{PREFIX}/lib"
# copy LICENSE
mkdir_p "#{PREFIX}/licenses"
cp "#{SRC_DIR}/LICENSE.txt", "#{PREFIX}/licenses/#{SDL_MIXER}-LICENSE.txt"
