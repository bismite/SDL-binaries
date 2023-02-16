#!/bin/bash

cp -R assets linux
x86_64-w64-mingw32-gcc -Wall -std=c11 -O3 test.c -o mingw/test \
  -Lmingw/bin -Lmingw/lib -Imingw/include \
  -lmingw32 -lSDL2main -lSDL2 -lSDL2_image -lSDL2_mixer -lopengl32
