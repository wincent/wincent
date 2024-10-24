#!/bin/zsh

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title GitHub user
# @raycast.mode silent

# Optional parameters:
# @raycast.icon ./github.png
# @raycast.argument1 { "type": "text", "optional": true, "placeholder": "name", "percentEncoded": false }

# Documentation:
# @raycast.description Find or jump to a specified GitHub user

# Get path to current script's directory:
# https://unix.stackexchange.com/a/115431/140622
BASE_DIRECTORY=${0:a:h}
source "$BASE_DIRECTORY/.common.zsh"

HANDLE=$(trim "$1")
HANDLE=$(space_to_plus "$HANDLE")

if [ -z "$HANDLE" ]; then
  HANDLE=$(git config github.username 2> /dev/null || echo "$USER")
  open "https://github.com/$HANDLE"
elif [[ $HANDLE == *\? ]]; then
  # Trim trailing "?" suffix.
  HANDLE=$(chop "$HANDLE")
  open "https://github.com/search?q=${HANDLE}&type=users"
else
  open "https://github.com/${HANDLE}"
fi
