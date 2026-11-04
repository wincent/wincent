#!/usr/bin/env bash
# Check that every st patch in themes/st applies cleanly to the st release
# named in its filename (st-<system>-<slug>-<version>.diff).
#
# Usage: scripts/check-st-patches.sh [patch-dir]
set -euo pipefail

patch_dir=$(cd "${1:-themes/st}" && pwd)
work_dir=$(mktemp -d)
trap 'rm -rf "$work_dir"' EXIT

failed=0
checked=0
for version in $(find "$patch_dir" -name 'st-*.diff' | sed -E 's/.*-([0-9.]+)\.diff$/\1/' | sort -u); do
  echo "Fetching st-$version"
  curl -fsSL "https://dl.suckless.org/st/st-$version.tar.gz" | tar -xz -C "$work_dir"

  for patch in "$patch_dir"/st-*-"$version".diff; do
    checked=$((checked + 1))
    if ! output=$(git -C "$work_dir/st-$version" apply --check -p1 "$patch" 2>&1); then
      echo "Does not apply: ${patch##*/}"
      echo "$output" | sed 's/^/  /'
      failed=$((failed + 1))
    fi
  done
done

if [ "$checked" -eq 0 ]; then
  echo "No st patches found in $patch_dir" >&2
  exit 1
fi

if [ "$failed" -gt 0 ]; then
  echo "$failed of $checked st patch(es) do not apply" >&2
  exit 1
fi
echo "All $checked st patches apply"
