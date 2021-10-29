#!/bin/zsh

# Trim trailing character from string:
# https://unix.stackexchange.com/a/259042/140622
function chop() {
  local STR="$1"
  echo "${STR[1,-2]}"
}

# Trim leading and trailing whitespace:
# https://stackoverflow.com/a/68288735/2103996
function trim() {
  local STR="$1"
  echo "${(MS)STR##[[:graph:]]*[[:graph:]]}"
}
