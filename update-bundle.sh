#!/usr/local/bin/zsh

set -e

SCRIPT=${(%):-%N} # via http://stackoverflow.com/a/23259585
. "$SCRIPT/../.shells/path" # make sure we can find preferred Vim

typeset -A REVS
REVS=(
  command-t next
  vim-colors-solarized italics
  YouCompleteMe a1feade
)

git submodule foreach git checkout master

for PROJECT in ${(k)REVS}; do
  cd .vim/bundle/$PROJECT
  git checkout $REVS[$PROJECT]
  cd -
done

git submodule foreach 'git pull --recurse-submodules || :'

# when YouCompleteMe updates, install it with its install.sh script
cd .vim/bundle/YouCompleteMe
git submodule update --init --recursive
cd -

vim -c "Helptags | quit"
