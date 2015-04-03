.PHONY: all help vim

# Default target.
help:
	@echo 'make all      - install everything'
	@echo 'make vim      - install Vim configuration'

all: vim

# TODO: consider running YouCompleteMe/install.sh on first run
vim:
	git submodule foreach 'BRANCH=$$(git config -f $$toplevel/.gitmodules submodule."$$path".branch || echo master) && git checkout $$BRANCH'
	git submodule foreach 'git pull --recurse-submodules || :'
	(cd .vim/bundle/YouCompleteMe && git submodule update --init --recursive)
	vim -u NONE -N -c 'runtime bundle/vim-pathogen/autoload/pathogen.vim | Helptags | quit'
