#!/bin/sh

./pack-src.sh
cd build
makepkg -si --needed
