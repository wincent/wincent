#!/bin/zsh

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title GitHub pulls
# @raycast.mode silent

# Optional parameters:
# @raycast.icon ./github.png
# @raycast.argument1 { "type": "text", "optional": true, "placeholder": "repo", "percentEncoded": false }

# Documentation:
# @raycast.description Jump to a specified GitHub repo's pull requests

# Get path to current script's directory:
# https://unix.stackexchange.com/a/115431/140622
BASE_DIRECTORY=${0:a:h}
source "$BASE_DIRECTORY/.common.zsh"

REPO=$(trim "$*")

if [ -z "$REPO" ]; then
  open "https://github.com/github/github/pulls"
elif [[ $REPO != */* ]]; then
  REPO=$(percent_encode "$REPO")
  open "https://github.com/github/${REPO}/pulls"
else
  OWNER=$(dirname "$REPO")
  OWNER=$(percent_encode "$OWNER")
  REPO=$(basename "$REPO")
  REPO=$(percent_encode "$REPO")
  open "https://github.com/${OWNER}/${REPO}/pulls"
fi
