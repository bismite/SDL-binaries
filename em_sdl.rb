#!/usr/bin/env ruby
require "fileutils"
include FileUtils

SDL="SDL2-2.26.4"

SRCS=%w(
  SDL.c SDL_assert.c SDL_dataqueue.c SDL_error.c SDL_guid.c SDL_hints.c SDL_list.c SDL_log.c SDL_utils.c
  atomic/SDL_atomic.c atomic/SDL_spinlock.c
  audio/SDL_audio.c audio/SDL_audiocvt.c audio/SDL_audiodev.c audio/SDL_audiotypecvt.c audio/SDL_mixer.c audio/SDL_wave.c
  cpuinfo/SDL_cpuinfo.c
  dynapi/SDL_dynapi.c
  events/SDL_clipboardevents.c events/SDL_displayevents.c events/SDL_dropevents.c
  events/SDL_events.c events/SDL_gesture.c events/SDL_keyboard.c events/SDL_mouse.c events/SDL_quit.c
  events/SDL_touch.c events/SDL_windowevents.c
  file/SDL_rwops.c
  haptic/SDL_haptic.c
  joystick/controller_type.c joystick/SDL_gamecontroller.c joystick/SDL_joystick.c
  power/SDL_power.c
  render/SDL_d3dmath.c render/SDL_render.c render/SDL_yuv_sw.c render/direct3d/SDL_render_d3d.c
  render/direct3d11/SDL_render_d3d11.c render/opengl/SDL_render_gl.c render/opengl/SDL_shaders_gl.c
  render/opengles/SDL_render_gles.c render/opengles2/SDL_render_gles2.c render/opengles2/SDL_shaders_gles2.c
  render/psp/SDL_render_psp.c render/software/SDL_blendfillrect.c render/software/SDL_blendline.c
  render/software/SDL_blendpoint.c render/software/SDL_drawline.c render/software/SDL_drawpoint.c
  render/software/SDL_render_sw.c render/software/SDL_rotate.c render/software/SDL_triangle.c
  sensor/SDL_sensor.c sensor/dummy/SDL_dummysensor.c
  stdlib/SDL_crc16.c stdlib/SDL_crc32.c stdlib/SDL_getenv.c stdlib/SDL_iconv.c stdlib/SDL_malloc.c
  stdlib/SDL_qsort.c stdlib/SDL_stdlib.c stdlib/SDL_string.c stdlib/SDL_strtokr.c
  thread/SDL_thread.c
  timer/SDL_timer.c
  video/SDL_RLEaccel.c video/SDL_blit.c video/SDL_blit_0.c video/SDL_blit_1.c video/SDL_blit_A.c
  video/SDL_blit_N.c video/SDL_blit_auto.c video/SDL_blit_copy.c video/SDL_blit_slow.c
  video/SDL_bmp.c video/SDL_clipboard.c video/SDL_egl.c video/SDL_fillrect.c video/SDL_pixels.c
  video/SDL_rect.c video/SDL_shape.c video/SDL_stretch.c video/SDL_surface.c video/SDL_video.c
  video/SDL_yuv.c
  video/emscripten/SDL_emscriptenevents.c video/emscripten/SDL_emscriptenframebuffer.c video/emscripten/SDL_emscriptenmouse.c
  video/emscripten/SDL_emscriptenopengles.c video/emscripten/SDL_emscriptenvideo.c
  audio/emscripten/SDL_emscriptenaudio.c
  video/dummy/SDL_nullevents.c video/dummy/SDL_nullframebuffer.c video/dummy/SDL_nullvideo.c
  video/yuv2rgb/yuv_rgb.c
  audio/disk/SDL_diskaudio.c audio/dummy/SDL_dummyaudio.c
  loadso/dlopen/SDL_sysloadso.c
  power/emscripten/SDL_syspower.c
  joystick/emscripten/SDL_sysjoystick.c
  filesystem/emscripten/SDL_sysfilesystem.c
  timer/unix/SDL_systimer.c
  haptic/dummy/SDL_syshaptic.c
  main/dummy/SDL_dummy_main.c
  locale/SDL_locale.c locale/emscripten/SDL_syslocale.c
  misc/SDL_url.c misc/emscripten/SDL_sysurl.c
)

THREAD_SRCS = %w(
  thread/generic/SDL_syscond.c
  thread/generic/SDL_sysmutex.c
  thread/generic/SDL_syssem.c
  thread/generic/SDL_systhread.c
  thread/generic/SDL_systls.c
)

def cmd(c)
  puts c
  exit unless system(c)
end

# clean and extract
rm_rf ["em/#{SDL}", "em/sdl"]
mkdir_p "em/sdl"
cmd "tar xf #{SDL}.tar.gz -C em"
# header install
mkdir_p "em/include/SDL2"
Dir.glob("em/#{SDL}/include/*.h").each{|h| cp h, "em/include/SDL2" unless h =~ /SDL_test/ }
# compile
Dir.chdir("em/sdl"){
  (SRCS+THREAD_SRCS).each{|s|
    src = "../#{SDL}/src/#{s}"
    cmd "emcc -Wall -g -sSTRICT -flto -O2 -c #{src} -sUSE_SDL=0 -I../include/SDL2"
  }
  cmd "emar cr libSDL2.a *.o"
}
# lib install
mkdir_p "em/lib"
cp "em/sdl/libSDL2.a", "em/lib/"
# copy LICENSE
mkdir_p "em/licenses"
cp "em/#{SDL}/LICENSE.txt", "em/licenses/#{SDL}-LICENSE.txt"
