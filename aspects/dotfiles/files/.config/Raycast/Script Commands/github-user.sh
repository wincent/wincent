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

HANDLE=$1

# Trim leading and trailing whitespace:
# https://stackoverflow.com/a/68288735/2103996
TRIMMED=${(MS)HANDLE##[[:graph:]]*[[:graph:]]}

if [ -z "$TRIMMED" ]; then
  open "https://github.com/$USER"
elif [[ $TRIMMED == *\? ]]; then
  # Trim trailing "?" suffix: https://unix.stackexchange.com/a/259042/140622
  TRIMMED=${TRIMMED[1,-2]}
  open "https://github.com/search?q=${TRIMMED}&type=users"
else
  open "https://github.com/${TRIMMED}"
fi
