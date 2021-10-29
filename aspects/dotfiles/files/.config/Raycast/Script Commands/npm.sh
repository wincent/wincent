#!/bin/zsh

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title npm
# @raycast.mode silent

# Optional parameters:
# @raycast.icon ./npm.png
# @raycast.argument1 { "type": "text", "optional": true, "placeholder": "package", "percentEncoded": false }

# Documentation:
# @raycast.description Find or jump to a specified npm package

PACKAGE=$1

# Trim leading and trailing whitespace:
# https://stackoverflow.com/a/68288735/2103996
TRIMMED=${(MS)PACKAGE##[[:graph:]]*[[:graph:]]}

if [ -z "$TRIMMED" ]; then
  open https://www.npmjs.com/
elif [[ $TRIMMED == *\? ]]; then
  # Trim trailing "?" suffix: https://unix.stackexchange.com/a/259042/140622
  TRIMMED=${TRIMMED[1,-2]}
  open "https://www.npmjs.com/search?q=${TRIMMED}"
else
  open "https://www.npmjs.com/package/${TRIMMED}"
fi
