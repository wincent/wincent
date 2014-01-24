#!/bin/sh

set -e

# usually this means running on a machine with a statically-linked, hand-built
# tmux (and ncurses)
if [ -d $HOME/share/terminfo ]; then
  export TERMINFO=$HOME/share/terminfo
else
  export TERMINFO=$HOME/.terminfo
fi

mkdir -p $TERMINFO
mkdir -p dry-run

patch_terminfo() {
  T=$1
  infocmp $T > $T.terminfo.original
  tic -o dry-run $T.terminfo
  infocmp -A dry-run $T > $T.terminfo.new
  echo ----- $T -----
  diff -u $T.terminfo.{original,new} || true
  echo ----- $T -----
  tic $T.terminfo
}

patch_terminfo screen-256color
patch_terminfo screen
patch_terminfo xterm-256color
