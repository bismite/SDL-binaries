#include <SDL2/SDL.h>
#include <SDL2/SDL_image.h>
#include <SDL2/SDL_mixer.h>
#include <stdbool.h>

#ifdef EMSCRIPTEN
#include <GLES3/gl3.h>
#include <emscripten.h>
#else
#include <SDL2/SDL_opengl.h>
#endif

#define PNG_FILE "assets/sample.png"
#define JPG_FILE "assets/sample.jpg"
#define MP3_FILE "assets/sample.mp3"
#define OGG_FILE "assets/sample.ogg"
Mix_Music *music_mp3=NULL;
Mix_Music *music_ogg=NULL;

static void print_version(const char* name,const SDL_version *v)
{
  printf("%s : %u.%u.%u\n", name, v->major, v->minor, v->patch);
}

static void init()
{
  SDL_Init(SDL_INIT_VIDEO);

  SDL_version v;
  SDL_VERSION(&v);
  print_version("SDL(compile)",&v);
  SDL_GetVersion(&v);
  print_version("SDL(link)",&v);

  SDL_IMAGE_VERSION(&v)
  print_version("Image(compile)", &v);
  print_version("Image(link)", IMG_Linked_Version() );
  SDL_MIXER_VERSION(&v)
  print_version("Mixer(compile)", &v);
  print_version("Mixer(link)", Mix_Linked_Version() );

  int flag = MIX_INIT_FLAC|MIX_INIT_MOD|MIX_INIT_MP3|MIX_INIT_OGG|MIX_INIT_MID|MIX_INIT_OPUS;
  int i = Mix_Init(flag);
  if(i&MIX_INIT_FLAC) printf("MIX_INIT_FLAC\n");
  if(i&MIX_INIT_MOD) printf("MIX_INIT_MOD\n");
  if(i&MIX_INIT_MP3) printf("MIX_INIT_MP3\n");
  if(i&MIX_INIT_OGG) printf("MIX_INIT_OGG\n");
  if(i&MIX_INIT_MID) printf("MIX_INIT_MID\n");
  if(i&MIX_INIT_OPUS) printf("MIX_INIT_OPUS\n");

  flag = IMG_INIT_JPG|IMG_INIT_PNG|IMG_INIT_TIF|IMG_INIT_WEBP|IMG_INIT_JXL|IMG_INIT_AVIF;
  i=IMG_Init(flag);
  if(i&IMG_INIT_JPG) printf("IMG_INIT_JPG\n");
  if(i&IMG_INIT_PNG) printf("IMG_INIT_PNG\n");
  if(i&IMG_INIT_TIF) printf("IMG_INIT_TIF\n");
  if(i&IMG_INIT_WEBP) printf("IMG_INIT_WEBP\n");
  if(i&IMG_INIT_JXL) printf("IMG_INIT_JXL\n");
  if(i&IMG_INIT_AVIF) printf("IMG_INIT_AVIF\n");
}

static void mixer_init()
{
  printf("open_audio\n");
  Mix_Init(MIX_INIT_MP3|MIX_INIT_OGG);
  if( Mix_OpenAudio(44100, MIX_DEFAULT_FORMAT, MIX_DEFAULT_CHANNELS, 4096) == 0 ){
    printf("Mix_OpenAudio succeeded.\n");
  }else{
    printf("Mix_OpenAudio failed.\n");
  }
  int channels = Mix_AllocateChannels(16);
  printf("%d channels allocated\n", channels);
}

static void main_loop( void* arg )
{
  SDL_Event e;
  while (SDL_PollEvent(&e)) {
    switch (e.type) {
    case SDL_MOUSEMOTION:
      Mix_VolumeMusic(MIX_MAX_VOLUME * e.motion.y / 240.0 );
      break;
    case SDL_MOUSEBUTTONDOWN:
      if(e.button.button==SDL_BUTTON_RIGHT) {
        // stutter
        for(int i=0;i<3;i++){
          printf("Stutter %dsec...\n",3-i);
          SDL_Delay(1000);
        }
      }else{
        if( Mix_PlayingMusic() ){
          double pos = Mix_MusicDuration(NULL) * e.button.x / 320.0;
          printf("Set Position %.2f sec\n",pos);
          Mix_SetMusicPosition( pos );
        }
      }
      break;
    case SDL_KEYDOWN:
      if(e.key.keysym.sym == SDLK_m){
        printf("play mp3\n");
        Mix_FadeInMusic(music_mp3,-1,3000);
      }else if(e.key.keysym.sym == SDLK_o){
        printf("play ogg\n");
        Mix_FadeInMusic(music_ogg,-1,3000);
      }
      break;
    case SDL_QUIT:
      exit(0);
      break;
    }
  }
}

static SDL_Window* init_window()
{
  SDL_SetHint(SDL_HINT_RENDER_DRIVER,"opengl");
#if defined(__EMSCRIPTEN__)
  SDL_GL_SetAttribute(SDL_GL_CONTEXT_PROFILE_MASK, SDL_GL_CONTEXT_PROFILE_ES);
  SDL_GL_SetAttribute(SDL_GL_CONTEXT_MAJOR_VERSION, 3);
  SDL_GL_SetAttribute(SDL_GL_CONTEXT_MINOR_VERSION, 0);
#else
  SDL_GL_SetAttribute(SDL_GL_ACCELERATED_VISUAL, 1);
  SDL_GL_SetAttribute(SDL_GL_CONTEXT_MAJOR_VERSION, 4);
  SDL_GL_SetAttribute(SDL_GL_CONTEXT_MINOR_VERSION, 1);
  SDL_GL_SetAttribute(SDL_GL_CONTEXT_PROFILE_MASK, SDL_GL_CONTEXT_PROFILE_CORE);
#endif

  Uint32 flag = SDL_WINDOW_OPENGL;
  SDL_Window* window = SDL_CreateWindow(__FILE__, SDL_WINDOWPOS_UNDEFINED, SDL_WINDOWPOS_UNDEFINED, 320, 240, flag);

  // GL Version
  SDL_GLContext *glcontext = SDL_GL_CreateContext(window);
  if(glcontext==NULL){
    printf("SDL_GL_CreateContext failed: %s\n",SDL_GetError());
    exit(1);
  }
  printf("GL_VENDOR: %s\n", glGetString(GL_VENDOR));
  printf("GL_VERSION: %s\n", glGetString(GL_VERSION));
  printf("GL_RENDERER: %s\n", glGetString(GL_RENDERER));
  printf("GL_SHADING_LANGUAGE_VERSION: %s\n", glGetString(GL_SHADING_LANGUAGE_VERSION));

  return window;
}

int main(int argc, char *argv[])
{
  init();
  SDL_Window* window = init_window();

  // Renderer
  SDL_Renderer *render = SDL_CreateRenderer(window, -1, 0);
  if(render==NULL){
    printf("SDL_CreateRenderer failed: %s\n",SDL_GetError());
  }
  SDL_RendererInfo info;
  SDL_GetRendererInfo(render,&info);
  printf("Renderer %s\n", info.name);
  if(info.flags&SDL_RENDERER_SOFTWARE) printf("SDL_RENDERER_SOFTWARE\n");
  if(info.flags&SDL_RENDERER_ACCELERATED) printf("SDL_RENDERER_ACCELERATED\n");
  if(info.flags&SDL_RENDERER_PRESENTVSYNC) printf("SDL_RENDERER_PRESENTVSYNC\n");
  if(info.flags&SDL_RENDERER_TARGETTEXTURE) printf("SDL_RENDERER_TARGETTEXTURE\n");

  // Image load and render
  SDL_Surface* img_png = IMG_Load(PNG_FILE);
  SDL_Surface* img_jpg = IMG_Load(JPG_FILE);
  if(img_png==NULL) { printf("png load failed\n"); }
  if(img_jpg==NULL) { printf("jpg load failed\n"); }
  SDL_SetRenderDrawColor(render,0,0,0,0);
  SDL_RenderClear(render);
  SDL_Rect png_dst = {0,0,160,240};
  SDL_Rect jpg_dst = {160,0,160,240};
  SDL_RenderCopy(render, SDL_CreateTextureFromSurface(render,img_png), NULL, &png_dst);
  SDL_RenderCopy(render, SDL_CreateTextureFromSurface(render,img_jpg), NULL, &jpg_dst);
  SDL_RenderPresent(render);

  mixer_init();
  Mix_VolumeMusic(MIX_MAX_VOLUME/4);
  // music load
  music_mp3 = Mix_LoadMUS_RW(SDL_RWFromFile(MP3_FILE,"rb"),SDL_TRUE);
  if(music_mp3==NULL) printf("mp3 load failed.\n");
  music_ogg = Mix_LoadMUS_RW(SDL_RWFromFile(OGG_FILE,"rb"),SDL_TRUE);
  if(music_ogg==NULL) printf("ogg load failed\n");

#ifdef EMSCRIPTEN
  emscripten_set_main_loop_arg(main_loop, NULL, 0, false);
#else
  while(1){
    main_loop(NULL);
    SDL_Delay(20);
  }
#endif
}
