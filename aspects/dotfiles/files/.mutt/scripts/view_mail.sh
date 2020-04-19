#!/bin/sh

COLUMNS=${COLUMNS:-`tput cols`}
TMPFILE="$1"
ENCODING="${2:utf-8}"

# Need to copy the file because mutt will delete it before Vim can read it.
DIR=$(mktemp -d)
cp "$TMPFILE" "$DIR/preview"
TMPFILE="$DIR/preview"

if [ -z "$TMUX" ]; then
  view "+set encoding=$ENCODING" '+set filetype=mail' '+set nofoldenable' '+set nomodifiable' "$TMPFILE"
elif [ "$COLUMNS" -gt 180 ]; then
  tmux split-window -p 50 -h \
    view "+set encoding=$ENCODING" '+set filetype=mail' '+set nofoldenable' '+set nomodifiable' "$TMPFILE"
else
  tmux split-window -p 50 -v \
    view "+set encoding=$ENCODING" '+set filetype=mail' '+set nofoldenable' '+set nomodifiable' "$TMPFILE"
fi
