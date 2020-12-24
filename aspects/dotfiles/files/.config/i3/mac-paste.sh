#!/bin/bash

ACTIVE_WINDOW=$(xdotool getactivewindow)
KITTY_WINDOWS=$(xdotool search --class kitty)

# BUG: works fine # when called manually from CLI, but not when called from i3

if [ -n "${ACTIVE_WINDOW}" ]; then
  if [[ "${KITTY_WINDOWS[@]}" =~ "${ACTIVE_WINDOW}" ]]; then
    xdotool key --delay 12 ctrl+shift+v
  else
    xdotool key --delay 12 ctrl+v
  fi
fi
