#!/bin/sh
#
# Example notification handler for Clipper, using `terminal-notifier` on
# macOS. Point `handlers.notification.executable` in ~/.clipper.json at this
# script (or any adaptation of it):
#
#   {
#     "handlers": {
#       "notification": {
#         "executable": "/absolute/path/to/terminal-notifier.sh"
#       }
#     }
#   }
#
# Clipper pipes the validated JSON frame to this script on standard input;
# the script parses out the fields of interest (here via `jq`) and shells out
# to `terminal-notifier`. Adjust `-activate` to match whichever app you want
# brought to the front when the notification is clicked.
#
# Requires: jq, terminal-notifier (both on `$PATH`). On macOS, launchd has an
# impoverished `$PATH`, so we add the default Homebrew directory for
# convenience.

set -eu

json=$(cat)

if [ -d /opt/homebrew/bin ]; then
  PATH="$PATH:/opt/homebrew/bin"
fi

# Defensive `// ""`: jq would otherwise emit the literal string "null" for a
# JSON null, which is rarely what a human wants to see in a notification.
# Clipper itself rejects notifications without a non-empty title, so in
# practice title should already be populated by the time we get here.
title=$(printf    '%s' "$json" | jq -r '.title    // ""')
subtitle=$(printf '%s' "$json" | jq -r '.subtitle // ""')
message=$(printf  '%s' "$json" | jq -r '.message  // ""')

if [ -z "$title" ]; then
    printf >&2 'terminal-notifier.sh: empty title; ignoring notification\n'
    exit 0
fi

set -- -title "$title"
if [ -n "$subtitle" ]; then
    set -- "$@" -subtitle "$subtitle"
fi
if [ -n "$message" ]; then
    set -- "$@" -message "$message"
fi
set -- "$@" -activate net.kovidgoyal.kitty

exec terminal-notifier "$@"
