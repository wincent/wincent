#!/bin/sh

~/.mutt/hooks/notmuch.sh

find ~/.mail/Home/Home -type f -mtime -30d -exec sh -c 'cat {} | lbdb-fetchaddr' \;
