# My "dotfiles"

These should work reasonably well on current OS X and recent Red Hat-like
Linuxes.

## Features

* Sane Vim pasting via bracketed paste mode.
* Write access to local clipboard from local and remote hosts, inside and
  outside of tmux.
* Full mouse support (pane/split resizing, scrolling, text selection) in Vim and
  tmux.
* Focus/lost events for Vim inside tmux.
* Cursor shape toggles on entering Vim.
* Italics in the terminal.
* Bundles a (not-excessive) number of useful Vim plug-ins.

## Dependencies

* [tmux](http://tmux.sourceforge.net/) 1.9a+.
* [Vim](http://www.vim.org/) 7.4+ with Ruby and Python support (although there's
  a reasonable amount of feature detection in order to degrade gracefully).
* Relatively recent [Zsh](http://www.zsh.org/); older, staler Bash config still
  available as a fallback.
* Relatively recent [Git](http://git-scm.com/).
* [Clipper](https://wincent.com/products/clipper) for transparent access to the
  local system clipboard.
* On OS X, [iTerm2](http://www.iterm2.com/).
* [Python](https://www.python.org/) to perform setup via the included `install`
  command.

## Installation

### Clone

```sh
git clone --recursive git://git.wincent.com/wincent.git
```

Note that if you're behind a firewall you may need to set up a temporary
`~/.gitconfig` with appropriate proxy configuration with a format such as:

```
[http]
	proxy = fwdproxy:8080
```

### Install

```sh
./install        # installs everything on the local machine
./install --help # info on installing specific roles, force-installing etc
```

This sets up a local Python environment using the bundled virtualenv, bootstraps
Ansible, and then uses Ansible to copy the dotfiles and configure the machine.

As a fallback strategy, in case the `install` script fails, you can symlink the
dotfiles by hand with a command like the following:

```sh
for DOTFILE in $(find roles/dotfiles/files -maxdepth 1 -name '.*' | tail -n +2); do
  ln -sf $PWD/$DOTFILE ~
done
```

**Note:** The `ln -sf` command will overwrite existing files, but will fail to
overwrite existing directories.

## General characteristics

* For a long time I resisted the temptation to add a large number of aliases; I
  wanted to be able to sit down in front of any machine and be comfortable with
  the standard tools; there has been a little "feature creep" since then, but I
  feel things are still pretty much in control.
* My first goal with my Zsh config was to reach feature parity with what I had
  with Bash, and then add a minimal number of bells and whistles.
* For similar reasons, I've tried to keep my Vim config close to standard; it is
  relatively "pimped" out, but the core functionality is mostly unmodified.
* I've resisted importing massive swathes of configuration provided by other
  people, or large libraries of code, preferring instead to understand, research
  and implement features on an as-needed basis.
