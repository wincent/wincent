#!/bin/bash

FILE="$1"
HEIGHT="$2"

# TODO: figure out how to avoid hard-coding this; (`tput cols` always returns 80)
WIDTH=80

case $(file --brief --mime-type "$FILE") in
  image/*)
    chafa --fill=block --symbols=block --colors=256 --size="$WIDTH"x"$HEIGHT" "$FILE"
    ;;
  text/*)
    highlight --force --out-format=ansi -- "$FILE"
    ;;
  *)
    file --brief "$FILE"
    ;;
esac
