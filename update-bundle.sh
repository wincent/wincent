#!/bin/sh

set -e

git submodule foreach git checkout master

cd .vim/bundle/command-t
git checkout next
cd -

cd .vim/bundle/vim-colors-solarized
git checkout italics
cd -

git submodule foreach git pull --recurse-submodules

# once YouCompleteMe is stable again, will delete this
# when YouCompleteMe updates, install it with its install.sh script
cd .vim/bundle/YouCompleteMe
git checkout a1feade
git submodule update --init --recursive
cd -

vim -c "call pathogen#helptags() | quit"
