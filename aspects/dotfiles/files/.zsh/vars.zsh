# Don't `export` CDPATH (can cause problems with shell scripts etc).
CDPATH=.:~:~/code

test -d "$HOME/Documents" && append_to CDPATH "$HOME/Documents"
