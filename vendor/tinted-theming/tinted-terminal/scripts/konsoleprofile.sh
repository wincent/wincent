#!/bin/sh
# Wrapper around konsoleprofile that supports tmux passthrough.
#
# konsoleprofile works by sending an OSC 50 escape sequence to the
# terminal. When running inside tmux, these sequences are intercepted
# and discarded unless explicitly wrapped in a DCS passthrough.
#
# When inside tmux, this script temporarily enables allow-passthrough,
# sends the escape sequence, then restores the previous setting.
#
# Usage: konsoleprofile.sh <profile-options>
# Example: konsoleprofile.sh "ColorScheme=base16-ayu-dark"

if [ $# -eq 0 ]; then
    echo "Usage: $0 \"option=value[;option=value;...]\"" >&2
    exit 1
fi

if [ -n "$TMUX" ]; then
    prev="$(tmux show -gv allow-passthrough 2>/dev/null)"
    tmux set -g allow-passthrough on >/dev/null 2>&1
    printf '\033Ptmux;\033\033]50;%s\a\033\\' "$1"
    tmux set -g allow-passthrough "$prev" >/dev/null 2>&1
else
    printf '\033]50;%s\a' "$1"
fi
