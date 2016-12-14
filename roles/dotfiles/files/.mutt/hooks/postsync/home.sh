#!/bin/sh

~/.mutt/scripts/notmuch.sh

find ~/.mail/Home/Home -type f -mtime -30d -exec sh -c 'cat {} | lbdb-fetchaddr' \;
