#!/bin/zsh

# Trim trailing character from string:
# https://unix.stackexchange.com/a/259042/140622
function chop() {
  local STR="$1"
  echo "${STR[1,-2]}"
}

# Strictly speaking, may not exactly percent-encode the supplied argument, but
# mostly does (eg. spaces will become "+", "ñ" will become "%C3%B1" etc).
# Also, CGI.escape apparently sucks, as does everything else:
# https://stackoverflow.com/a/13059657/2103996
function percent_encode() {
  echo -n "$1" | ruby -rcgi -pe '$_ = CGI.escape($_)'
}

function space_to_plus() {
  echo -n "$1" | tr ' ' +
}

# Trim leading and trailing whitespace:
# https://stackoverflow.com/a/68288735/2103996
function trim() {
  local STR="$1"
  echo "${(MS)STR##[[:graph:]]*[[:graph:]]}"
}
