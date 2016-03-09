#!/bin/bash
# Prints a dump of ANSI colors.

for fgbg in 38 48 ; do # For foreground/background
  for color in {0..256} ; do # For all 256 colors
    printf "\e[${fgbg};5;${color}m ${color}\t\e[0m"
    # Newline after every 10 colors.
    if [ $((($color + 1) % 10)) == 0 ] ; then
      echo
    fi
  done
  echo # Final newline.
done
