#!/bin/bash

cp -R assets linux
clang -Wall -std=c11 -O3 test.c -o linux/test \
  -Lmacos/lib -Imacos/include \
  -lSDL2 -lSDL2_image -lSDL2_mixer -lGL
