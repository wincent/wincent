#!/bin/zsh

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title GitHub repo
# @raycast.mode silent

# Optional parameters:
# @raycast.icon ./github.png
# @raycast.argument1 { "type": "text", "optional": true, "placeholder": "name", "percentEncoded": false }

# Documentation:
# @raycast.description Find or jump to a specified GitHub repo

# Get path to current script's directory:
# https://unix.stackexchange.com/a/115431/140622
BASE_DIRECTORY=${0:a:h}
source "$BASE_DIRECTORY/.common.zsh"

NAME=$(trim "$*")

if [ -z "$NAME" ]; then
  open "https://github.com/github/github"
elif [[ $NAME == *\? ]]; then
  # Trim trailing "?" suffix.
  NAME=$(chop "$NAME")
  echo -n "$NAME" | while IFS=' ' read -A ARGS; do
    echo "${ARGS[1]}"
  done
  if [ $#ARGS -eq 2 ]; then
    NAME="org:$ARGS[1] $ARGS[2]"
    NAME=$(space_to_plus "$NAME")
    open "https://github.com/search?q=${NAME}&type=repositories"
  else
    NAME=$(space_to_plus "$NAME")
    open "https://github.com/search?q=${NAME}&type=repositories"
  fi
elif [[ $NAME != */* ]]; then
  NAME=$(space_to_plus "$NAME")
  open "https://github.com/github/${NAME}"
else
  NAME=$(space_to_plus "$NAME")
  open "https://github.com/${NAME}"
fi
