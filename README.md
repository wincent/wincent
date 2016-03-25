# "dotfiles" and system configuration

![](https://raw.githubusercontent.com/wincent/wincent/media/screenshot.png)

* Target platforms: OS X and Red Hat-like Linuxes (eg. CentOS).
* Set-up method: ~~Beautiful and intricate snowflake~~ incredibly over-engineered [Ansible](https://www.ansible.com/) orchestration.

## Features

### Dotfiles

[A set of dotfiles](https://github.com/wincent/wincent/tree/master/roles/dotfiles/files) that I've been tweaking and twiddling since the early 2000s ([under version control](https://github.com/wincent/wincent/commit/61a7e2a830edb7) since 2009). Characteristics include:

* Sane Vim pasting via bracketed paste mode.
* Write access to local clipboard from local and remote hosts, inside and outside of tmux (via [Clipper](https://github.com/wincent/clipper)).
* Full mouse support (pane/split resizing, scrolling, text selection) in Vim and tmux.
* Focus/lost events for Vim inside tmux.
* Cursor shape toggles on entering Vim.
* Italics in the terminal.
* Bundles a (not-excessive) number of [useful Vim plug-ins](https://github.com/wincent/wincent/tree/master/roles/dotfiles/files/.vim/bundle).
* Relative restrained Zsh config, Bash-like but with a few Zsh perks.
* Unified color-handling via [Base16 Shell](https://github.com/chriskempson/base16-shell).
* Encrypted versioning of files with sensitive content (via [git-cipher](https://github.com/wincent/git-cipher)).
* Comprehensive [Hammerspoon](http://www.hammerspoon.org/) [config](https://github.com/wincent/wincent/tree/master/roles/dotfiles/files/.hammerspoon).

### Homebrew

On OS X, [the `homebrew` role](https://github.com/wincent/wincent/tree/master/roles/homebrew) installs [a bunch of useful software](https://github.com/wincent/wincent/blob/master/roles/homebrew/files/Brewfile).

### Keyboard customization

On OS X, [the `keyboard` role](https://github.com/wincent/wincent/tree/master/roles/keyboard) uses [Karabiner](https://pqrs.org/osx/karabiner/) to:

* Make Caps Lock serve as Backspace (when tapped), repeated Backspace (when pressed and held), and Left Control (when chorded with another key).
* Make Return serve as Return (when tapped), repeated Return (when pressed and held), and Right Control (when chorded with another key).
* Turn Caps Lock on by tapping both Shift keys simultaneously (turn it off by tapping either Shift key on its own).
* Adds a "SpaceFN" layer that can be activated by holding down Space while hitting other keys; I use this to make the cursor keys available on or near the home row in any app.
* Make the YubiKey work with the Colemak keyboard layout.
* Makes the function keys on my external Realforce keyboard behave like the "media" keys on Apple's keyboards.

## Dependencies

* [tmux](http://tmux.sourceforge.net/) 2.2 or later.
* [Vim](http://www.vim.org/) 7.4 or later with Ruby and Python support (although there's a reasonable amount of feature detection in order to degrade gracefully).
* Relatively recent [Zsh](http://www.zsh.org/).
* Relatively recent [Git](http://git-scm.com/).
* [Clipper](https://wincent.com/products/clipper) for transparent access to the local system clipboard.
* On OS X, [iTerm2](http://www.iterm2.com/).
* [Python](https://www.python.org/) to perform setup via the included `install` command.

## Installation

### Clone

```sh
git clone --recursive https://github.com/wincent/wincent.git
```

Note that if you're behind a firewall you may need to set up a temporary `~/.gitconfig` with appropriate proxy configuration with a format such as:

```
[http]
	proxy = fwdproxy:8080
```

### Install

```sh
./install        # installs everything on the local machine
./install --help # info on installing specific roles, force-installing etc
```

This sets up a local Python environment using the bundled virtualenv, bootstraps Ansible, and then uses Ansible to copy the dotfiles and configure the machine.

As a fallback strategy, in case the `install` script fails, you can symlink the dotfiles by hand with a command like the following:

```sh
for DOTFILE in $(find roles/dotfiles/files -maxdepth 1 -name '.*' | tail -n +2); do
  ln -sf $PWD/$DOTFILE ~
done
```

**Note:** The `ln -sf` command will overwrite existing files, but will fail to overwrite existing directories.

## Design process

* For a long time I resisted the temptation to add a large number of aliases; I wanted to be able to sit down in front of any machine and be comfortable with the standard tools; there has been a little "feature creep" since then, but I feel things are still pretty much in control.
* My first goal with my Zsh config was to reach feature parity with what I had with Bash, and then add a minimal number of bells and whistles.
* For similar reasons, I've tried to keep my Vim config close to standard; it is relatively "pimped" out, but the core functionality is mostly unmodified.
* I've resisted importing massive swathes of configuration provided by other people, or large libraries of code, preferring instead to understand, research and implement features on an as-needed basis.
