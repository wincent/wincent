#!/bin/bash

FILE="$1"
WIDTH="$2" # Width of preview area; for full width of `lf` UI, see $lf_width.
HEIGHT="$3" # Height of preview area; for full height of `lf` UI, see $lf_height.

# For some reason, $WIDTH seems to overstate the number of available columns by
# about 10%, so adjust it down to 90% of initial value.
WIDTH=$((WIDTH / 10 * 9))
WIDTH=$((WIDTH < 10 ? $2 : WIDTH)) # Too small. Just leave it as it was.

case $(file --brief --mime-type "$FILE") in
  image/*)
    chafa --fill=block --symbols=block --colors=256 --size="$WIDTH"x"$HEIGHT" "$FILE"
    ;;
  application/json | text/*)
    if [[ $FILE == *.md ]]; then
      # Need `-s dark` to force color outside of interactive shell:
      # https://github.com/charmbracelet/glow/issues/440
      glow -s dark --width "$WIDTH" "$FILE"
    else
      highlight --force --out-format=ansi -- "$FILE"
    fi
    ;;
  *)
    file --brief "$FILE"
    ;;
esac
