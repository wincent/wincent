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

# Get path to current script's directory:
# https://unix.stackexchange.com/a/115431/140622
BASE_DIRECTORY=${0:a:h}
source "$BASE_DIRECTORY/.common.zsh"

PACKAGE=$(trim "$1")

if [ -z "$PACKAGE" ]; then
  open https://www.npmjs.com/
elif [[ $PACKAGE == *\? ]]; then
  # Trim trailing "?" suffix.
  PACKAGE=$(chop "$PACKAGE")
  PACKAGE=$(percent_encode "$PACKAGE")
  open "https://www.npmjs.com/search?q=${PACKAGE}"
else
  PACKAGE=$(percent_encode "$PACKAGE")
  open "https://www.npmjs.com/package/${PACKAGE}"
fi
