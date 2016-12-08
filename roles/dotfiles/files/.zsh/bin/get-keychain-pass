#!/bin/sh

if [ $# -ne 2 ]; then
  echo "Usage: $0 ACCOUNT SERVER"
  exit 1
fi
ACCOUNT="$1"
SERVER="$2"
KEYCHAIN="$HOME/Library/Keychains/login.keychain"
PASSAGE_SOCK="$HOME/.passage.sock"

if [ -S "$PASSAGE_SOCK" ]; then
  # TODO: consider validating this as valid JSON
  echo "{\"service\":\"$SERVER\",\"account\":\"$ACCOUNT\"}" | nc -U "$PASSAGE_SOCK"
  echo # For parity with `security`, which prints a newline.
else
  security find-generic-password -w -a "$ACCOUNT" -s "$SERVER" "$KEYCHAIN"
fi
