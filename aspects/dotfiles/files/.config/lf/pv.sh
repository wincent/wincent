#!/bin/bash

shopt -s nocasematch

FILE="$1"
HEIGHT="$2"

# TODO: figure out how to avoid hard-coding this; (`tput cols` always returns 80)
WIDTH=80

case "$1" in
  *.gif|*.jpeg|*.jpg|*.png)
    chafa --fill=block --symbols=block --colors=256 --size="$WIDTH"x"$HEIGHT" "$FILE"
    ;;
  *)
    highlight --force --out-format=ansi -- "$FILE" || file -b "$FILE"
    ;;
esac
