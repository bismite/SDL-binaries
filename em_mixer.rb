#!/usr/bin/env ruby
require "fileutils"
include FileUtils

SRCS = %w(
  effect_position.c effect_stereoreverse.c effects_internal.c mixer.c music.c utils.c
) + %w(
  load_aiff.c mp3utils.c music_drflac.c music_flac.c music_modplug.c
  music_nativemidi.c music_ogg_stb.c music_timidity.c music_xmp.c load_voc.c
  music_cmd.c music_drmp3.c music_fluidsynth.c music_mpg123.c music_ogg.c
  music_opus.c music_wav.c
).map{|s| "codecs/#{s}" }

def cmd(c)
  puts c
  exit unless system c
end

SDL_MIXER="SDL2_mixer-2.6.3"
# clean and extract
rm_rf ["em/#{SDL_MIXER}", "em/sdl_mixer"]
mkdir_p "em/sdl_mixer"
cmd "tar xf #{SDL_MIXER}.tar.gz -C em"
# header install
mkdir_p "em/include/SDL2"
cp "em/#{SDL_MIXER}/include/SDL_mixer.h", "em/include/SDL2"
# compile
Dir.chdir("em/sdl_mixer"){
  (SRCS).each{|s|
    src = "../#{SDL_MIXER}/src/#{s}"
    include = "-I../#{SDL_MIXER}/src -I../#{SDL_MIXER}/src/codecs -I../include/SDL2"
    flags = "-DMUSIC_WAV -DMUSIC_MP3_DRMP3 -DMUSIC_OGG -DOGG_USE_STB"
    cmd "emcc -Wall -g -sSTRICT -flto -O2 -c #{src} -sUSE_SDL=0 #{flags} #{include}"
  }
  cmd "emar cr libSDL2_mixer.a *.o"
}
# lib install
mkdir_p "em/lib"
cp "em/sdl_mixer/libSDL2_mixer.a", "em/lib/"
# copy LICENSE
mkdir_p "em/licenses"
cp "em/#{SDL_MIXER}/LICENSE.txt", "em/licenses/#{SDL_MIXER}-LICENSE.txt"
