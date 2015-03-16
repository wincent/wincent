#!/bin/bash

command -v brew &> /dev/null || \
  { echo 'Homebrew required; see http://brew.sh/'; exit 1; }

brew tap Homebrew/brewdler
brew brewdle
