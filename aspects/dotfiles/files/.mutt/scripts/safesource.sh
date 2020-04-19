#!/bin/sh

# Helper to gracefully attempt to source a file that may not exist.
#
# Usage in muttrc:
#
#     source `$HOME/.mutt/scripts/safesource.sh $HOME/.mutt/config/example.mutt`

FILE=$1

if [ ! -s "$FILE" ]; then
  FILE=/dev/null
fi

echo "$FILE"
