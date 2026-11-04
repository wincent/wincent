#!/usr/bin/env bash
# Fail if a Rex theme's embedded Ghostty theme differs from the matching file
# in themes/ghostty/, or if either directory has a theme the other lacks.
#
# Usage: scripts/check-rex-themes.sh
set -euo pipefail

failed=0
checked=0

shopt -s nullglob
for rex in themes/rex/*.lua; do
  checked=$((checked + 1))
  name=$(basename "$rex" .lua)
  ghostty="themes/ghostty/$name"
  if [ ! -f "$ghostty" ]; then
    echo "No Ghostty theme for $rex: $ghostty is missing"
    failed=$((failed + 1))
    continue
  fi
  # Print the lines between `local theme = [==[` and `]==]`.
  if ! sed -n '/^local theme = \[==\[$/,/^\]==\]$/{//!p;}' "$rex" \
    | diff -u --label "$ghostty" --label "$rex" "$ghostty" -; then
    failed=$((failed + 1))
  fi
done

for ghostty in themes/ghostty/*; do
  rex="themes/rex/$(basename "$ghostty").lua"
  if [ ! -f "$rex" ]; then
    echo "No Rex theme for $ghostty: $rex is missing"
    failed=$((failed + 1))
  fi
done

if [ "$failed" -gt 0 ]; then
  echo "$failed Rex theme(s) don't match themes/ghostty/" >&2
  exit 1
fi

if [ "$checked" -eq 0 ]; then
  echo "No Rex themes found in themes/rex" >&2
  exit 1
fi
echo "All $checked Rex themes match themes/ghostty/"
