#!/bin/sh

lockrun --lockfile ~/.mutt/hooks/.notmuch.lock --quiet -- notmuch new
