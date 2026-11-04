#!/usr/bin/env bash
# Fail if any non-empty file under the given paths doesn't end with a newline.
#
# Usage: scripts/check-final-newline.sh <path>...
set -euo pipefail

if [ "$#" -eq 0 ]; then
  echo "Usage: $0 <path>..." >&2
  exit 2
fi

missing=0
checked=0
while IFS= read -r -d '' file; do
  checked=$((checked + 1))
  # $(...) strips a trailing newline, so a non-empty result means the last
  # byte is something else.
  if [ -s "$file" ] && [ -n "$(tail -c 1 "$file")" ]; then
    echo "Missing final newline: $file"
    missing=$((missing + 1))
  fi
done < <(find "$@" -type f -print0)

if [ "$missing" -gt 0 ]; then
  echo "$missing file(s) missing a final newline" >&2
  exit 1
fi
echo "All $checked files end with a newline"
