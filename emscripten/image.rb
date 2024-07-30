#!/usr/bin/env ruby
require "fileutils"
include FileUtils

VERSION=ARGV[0]
SDL_IMAGE="SDL2_image-#{VERSION}"
SRC_DIR="/tmp/#{SDL_IMAGE}"
BUILD_DIR="tmp/build/emscripten/#{SDL_IMAGE}"
PREFIX="#{Dir.pwd}/tmp/emscripten"

SRCS=%w(
  IMG.c IMG_avif.c IMG_bmp.c IMG_gif.c IMG_jpg.c IMG_jxl.c IMG_lbm.c IMG_pcx.c
  IMG_png.c IMG_pnm.c IMG_qoi.c IMG_stb.c IMG_svg.c IMG_tga.c
  IMG_tif.c IMG_xcf.c IMG_xpm.c IMG_xv.c IMG_webp.c IMG_ImageIO.m
)

def cmd(c)
  puts c
  exit unless system c
end

# clean and extract
rm_rf [BUILD_DIR, SRC_DIR]
mkdir_p SRC_DIR
cmd "tar xf #{SDL_IMAGE}.tar.gz -C /tmp/"
# header install
mkdir_p "#{PREFIX}/include/SDL2"
cp "#{SRC_DIR}/include/SDL_image.h", "#{PREFIX}/include/SDL2/"
# compile
mkdir_p BUILD_DIR
Dir.chdir(BUILD_DIR){
  (SRCS).each{|s|
    src = "#{SRC_DIR}/src/#{s}"
    include = "-I#{PREFIX}/include/SDL2 -I#{PREFIX}/include"
    flags = "-DUSE_STBIMAGE -DLOAD_PNG -DLOAD_JPG -sSTRICT -sUSE_SDL=0"
    cmd "emcc -Wall -g0 -flto -O2  #{include} #{flags} -c #{src}"
  }
  cmd "emar cr libSDL2_image.a *.o"
}
# lib install
mkdir_p "#{PREFIX}/lib"
cp "#{BUILD_DIR}/libSDL2_image.a", "#{PREFIX}/lib"
# copy LICENSE
mkdir_p "#{PREFIX}/licenses"
cp "#{SRC_DIR}/LICENSE.txt", "#{PREFIX}/licenses/#{SDL_IMAGE}-LICENSE.txt"
