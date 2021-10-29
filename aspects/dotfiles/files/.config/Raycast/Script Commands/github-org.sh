#!/bin/zsh

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title GitHub organization
# @raycast.mode silent

# Optional parameters:
# @raycast.icon ./github.png
# @raycast.argument1 { "type": "text", "optional": true, "placeholder": "name", "percentEncoded": false }

# Documentation:
# @raycast.description Find or jump to a specified GitHub organization

# Get path to current script's directory:
# https://unix.stackexchange.com/a/115431/140622
BASE_DIRECTORY=${0:a:h}
source "$BASE_DIRECTORY/.common.zsh"

ORG=$(trim "$1")

if [ -z "$ORG" ]; then
  open "https://github.com/github"
elif [[ $ORG == *\? ]]; then
  # Trim trailing "?" suffix.
  ORG=$(chop "$ORG")
  ORG=$(percent_encode "$ORG")
  open "https://github.com/search?q=${ORG}&type=users"
else
  ORG=$(percent_encode "$ORG")
  open "https://github.com/${ORG}"
fi
