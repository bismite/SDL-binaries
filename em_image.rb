#!/usr/bin/env ruby
require "fileutils"
include FileUtils

SRCS=%w(
  IMG.c IMG_avif.c IMG_bmp.c IMG_gif.c IMG_jpg.c IMG_jxl.c IMG_lbm.c IMG_pcx.c
  IMG_png.c IMG_pnm.c IMG_qoi.c IMG_stb.c IMG_svg.c IMG_tga.c
  IMG_tif.c IMG_xcf.c IMG_xpm.c IMG_xv.c IMG_webp.c IMG_ImageIO.m
)

def cmd(c)
  puts c
  exit unless system c
end

SDL_IMAGE="SDL2_image-2.6.3"
# clean and extract
rm_rf ["em/#{SDL_IMAGE}", "em/sdl_image"]
mkdir_p "em/sdl_image"
cmd "tar xf #{SDL_IMAGE}.tar.gz -C em"
# header install
mkdir_p "em/include/SDL2"
cp "em/#{SDL_IMAGE}/SDL_image.h", "em/include/SDL2"
# compile
Dir.chdir("em/sdl_image"){
  (SRCS).each{|s|
    src = "../#{SDL_IMAGE}/#{s}"
    include = "-I../#{SDL_IMAGE} -I../include/SDL2"
    flags = "-DUSE_STBIMAGE -DLOAD_PNG -DLOAD_JPG"
    cmd "emcc -Wall -g -sSTRICT -flto -O2 -c #{src} -sUSE_SDL=0 #{flags} #{include}"
  }
  cmd "emar cr libSDL2_image.a *.o"
}
# lib install
mkdir_p "em/lib"
cp "em/sdl_image/libSDL2_image.a", "em/lib/"
# copy LICENSE
mkdir_p "em/licenses"
cp "em/#{SDL_IMAGE}/LICENSE.txt", "em/licenses/#{SDL_IMAGE}-LICENSE.txt"
