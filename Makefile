.PHONY: all brew brewdler help homebrew vim

# Default target.
help:
	@echo 'make all      - install everything'
	@echo 'make homebrew - install/update Homebrew bundle'
	@echo 'make vim      - install Vim configuration'

all: homebrew vim

/usr/local/bin/brew:
	curl -L https://raw.githubusercontent.com/Homebrew/install/master/install -o install-homebrew
	ruby install-homebrew

/usr/local/Library/Taps/homebrew/homebrew-brewdler: | brew
	brew tap homebrew/brewdler

brew: | /usr/local/bin/brew

brewdler: | /usr/local/Library/Taps/homebrew/homebrew-brewdler

homebrew: brew brewdler
	brew brewdle

# TODO: consider running YouCompleteMe/install.sh on first run
vim:
	git submodule foreach 'BRANCH=$$(git config -f $$toplevel/.gitmodules submodule."$$path".branch || echo master) && git checkout $$BRANCH'
	git submodule foreach 'git pull --recurse-submodules || :'
	(cd .vim/bundle/YouCompleteMe && git submodule update --init --recursive)
	vim -u NONE -N -c 'runtime bundle/vim-pathogen/autoload/pathogen.vim | Helptags | quit'
