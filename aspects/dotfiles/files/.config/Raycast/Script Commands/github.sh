#!/bin/zsh

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title GitHub search
# @raycast.mode silent

# Optional parameters:
# @raycast.icon ./github.png
# @raycast.argument1 { "type": "text", "optional": true, "placeholder": "query", "percentEncoded": false }

# Documentation:
# @raycast.description Jump to or find something on GitHub

# Get path to current script's directory:
# https://unix.stackexchange.com/a/115431/140622
BASE_DIRECTORY=${0:a:h}
source "$BASE_DIRECTORY/.common.zsh"

QUERY=$(trim "$1")
QUERY=$(space_to_plus "$QUERY")

if [ -z "$QUERY" ]; then
  open "https://github.com/"
else
  open "https://github.com/search?q=${QUERY}"
fi
