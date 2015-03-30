PREFIX := $(HOME)
BACKUPS := $(PREFIX)/.backups
SRC_FILES := $(wildcard dot-*)
DOT_FILES := $(addprefix $(PREFIX)/,$(SRC_FILES:dot-%=.%))

# Sanity checks, because Make doesn't handle paths with spaces very well.
ifeq ('',$(strip $(PREFIX)))
$(error PREFIX must be non-empty)
endif
ifneq (1,$(words $(abspath $(PREFIX))))
$(error PREFIX must contain no whitespace)
endif
ifeq (,$PWD)
$(error PWD must be defined)
endif
ifeq ('',$(strip $(PWD)))
$(error PWD must be non-empty)
endif
ifneq (1,$(words $(abspath $(PWD))))
$(error PWD must contain no whitespace)
endif

.PHONY: all brew brewdler dotfiles help homebrew install terminfo vim

# Default target.
install: dotfiles

all: dotfiles homebrew terminfo vim

/usr/local/bin/brew:
	curl -L https://raw.githubusercontent.com/Homebrew/install/master/install -o install-homebrew
	ruby install-homebrew

/usr/local/Library/Taps/homebrew/homebrew-brewdler: | brew
	brew tap homebrew/brewdler

brew: | /usr/local/bin/brew

brewdler: | /usr/local/Library/Taps/homebrew/homebrew-brewdler

dotfiles: $(DOT_FILES)

homebrew: brew brewdler
	brew brewdle

# TODO: consider using recursive Makefile for this
terminfo:
	@echo TODO: implement

# TODO: consider running YouCompleteMe/install.sh on first run
vim:
	git submodule foreach 'BRANCH=$$(git config -f $$toplevel/.gitmodules submodule."$$path".branch || echo master) && git checkout $$BRANCH'
	git submodule foreach 'git pull --recurse-submodules || :'
	(cd .vim/bundle/YouCompleteMe && git submodule update --init --recursive)
	vim -u NONE -N -c 'runtime bundle/vim-pathogen/autoload/pathogen.vim | Helptags | quit'

$(BACKUPS):
	mkdir -p $@

$(PREFIX)/.%: $(BACKUPS) .FORCE
	@if [ -L "$@" ]; then \
		rm $@; \
	elif [ -e "$@" ]; then \
		rm -rf $(BACKUPS)/$(notdir $@); \
		mv $@ $(BACKUPS)/$(notdir $@); \
	fi; \
	echo Linking $@; \
	ln -s $(addprefix $(PWD)/,$(patsubst .%,dot-%,$(notdir $@))) $@

.FORCE:

help:
	@echo 'make all      - install everything'
	@echo 'make dotfiles - install dotfiles [default]'
	@echo 'make homebrew - install/update Homebrew bundle'
	@echo 'make terminfo - install terminfo entries'
	@echo 'make vim      - install Vim configuration'
	@echo
	@echo Examples:
	@echo '  # Install into /tmp/demo instead of default HOME prefix'
	@echo '  make PREFIX=/tmp/demo dotfiles'
