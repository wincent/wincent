# "dotfiles" and system configuration

![](https://github.com/wincent/wincent/workflows/ci/badge.svg)

![](https://raw.githubusercontent.com/wincent/wincent/media/screenshot.png)

-   Target platforms: macOS and Linux (see [Platform status](#platform-status) below).
-   Set-up method: ~~Beautiful and intricate snowflake~~ an incredibly over-engineered custom configuration framework called [Fig](./fig/README.md).
-   Visible in the screenshot:
    -   [default-dark Base16](http://chriskempson.com/projects/base16/) color scheme (see [screenshots of other colorschemes](https://github.com/wincent/wincent/blob/media/colorschemes/README.md)).
    -   [Adobe Source Code Pro](https://github.com/adobe-fonts/source-code-pro) (Light) font.
    -   [Neovim](https://neovim.io), running inside [tmux](https://github.com/tmux/tmux), inside [iTerm2](http://www.iterm2.com/), on macOS "High Sierra".

## Features

### Dotfiles

[A set of dotfiles](https://github.com/wincent/wincent/tree/master/aspects/dotfiles/files) that I've been tweaking and twiddling since the early 2000s ([under version control](https://github.com/wincent/wincent/commit/61a7e2a830edb7) since 2009). Characteristics include:

-   Sane Vim pasting via bracketed paste mode.
-   Write access to local clipboard from local and remote hosts, inside and outside of tmux (via [Clipper](https://github.com/wincent/clipper)).
-   Full mouse support (pane/split resizing, scrolling, text selection) in Vim and tmux.
-   Focus/lost events for Vim inside tmux.
-   Cursor shape toggles on entering Vim.
-   Italics in the terminal.
-   Bundles a (not-excessive) number of [useful Vim plug-ins](https://github.com/wincent/wincent/tree/master/aspects/vim/files/.vim/pack).
-   Conservative Vim configuration (very few overrides of core functionality; most changes are unobtrusive enhancements; some additional functionality exposed via `<Leader>` and `<LocalLeader>` mappings.
-   Relatively restrained Zsh config, Bash-like but with a few Zsh perks, such as right-side prompt, auto-cd hooks, command elapsed time printing and such.
-   Unified color-handling (across iTerm2 and Vim) via [Base16 Shell](https://github.com/chriskempson/base16-shell).
-   Encrypted versioning of files with sensitive content (via [git-cipher](https://github.com/wincent/git-cipher)).
-   Comprehensive [Hammerspoon](http://www.hammerspoon.org/) [config](https://github.com/wincent/wincent/tree/master/aspects/dotfiles/files/.hammerspoon).

### Homebrew

On macOS, [the "homebrew" aspect](https://github.com/wincent/wincent/tree/master/aspects/homebrew) installs [a bunch of useful software](https://github.com/wincent/wincent/blob/master/aspects/homebrew/templates/Brewfile.erb).

### Keyboard customization

On macOS, [Karabiner-Elements](https://github.com/tekezo/Karabiner-Elements/) is used for the following:

-   Make Caps Lock serve as Backspace (when tapped) and Left Control (when chorded with another key). When held down alone, Caps Lock fires repeated Backspace events.
-   Make Return serve as Return (when tapped) and Right Control (when chorded with another key). When held down alone, Return fires repeated Return events.
-   Maps Control-I to F6 (only in MacVim and the terminal) so that it can be mapped independently from Tab in Vim.
-   Toggle Caps Lock on by tapping both Shift keys simultaneously.
-   Makes the function keys on my external Realforce keyboard behave like the "media" keys on Apple's keyboards.
-   Swap Option and Command keys on my external Realforce keyboard.
-   Make the "application" key (extra modifier key on right-hand side) behave as "fn" on Realforce keyboard.
-   Make "pause" (at far-right of function key row) behave as "power" (effectively, sleep) on Realforce keyboard.
-   Adds a "SpaceFN" layer that can be activated by holding down Space while hitting other keys; I use this to make the cursor keys available on or near the home row in any app.

### Zsh

#### Functions

-   `ag`: Transparently wraps the `ag` executable so as to provide a centralized place to set defaults for that command (seeing as it has no "rc" file).
-   `bounce`: bounce the macOS Dock icon if the terminal is not in the foreground.
-   `color`: change terminal and Vim color scheme.
-   `fd`: "find directory" using fast `bfs` and `sk`; automatically `cd`s into the selected directory.
-   `fh`: "find [in] history"; selecting a history item inserts it into the command line but does not execute it.
-   `history`: overrides the (tiny) default history count.
-   `jump` (aliased to `j`): to jump to hashed directories.
-   `regmv`: bulk-rename files (eg. `regmv '/\.tif$/.tiff/' *`).
-   `scratch`: create a random temporary scratch directory and `cd` into it.
-   `tick`: moves an existing time warp (eg. `tick +1h`); see `tw` below for a description of time warp.
-   `tmux`: wrapper that reattches to pre-existing sessions, or creates new ones based on the current directory name; additionally, looks for a `.tmux` file to set up windows and panes (note that the first time a given `.tmux` file is encountered the wrapper asks the user whether to trust or skip it).
-   `tw` ("time warp"): overrides `GIT_AUTHOR_DATE` and `GIT_COMMITTER_DATE` (eg. `tw -1d`).

#### Prompt

Zsh is configured with the following prompt:

![](https://raw.githubusercontent.com/wincent/wincent/media/prompt.png)

Visible here are:

-   Concise left-hand prompt consisting of:
    -   Last component of current directory (abbreviates `$HOME` to `~` if possible).
    -   Prompt marker, `❯`, the "[HEAVY RIGHT-POINTING ANGLE QUOTATION MARK ORNAMENT](https://codepoints.net/U+276F)" (that's `\u276f`, or `e2 9d af` in UTF-8).
-   Extended right-hand size prompt which auto-hides when necessary to make room for long commands and contains:
    -   Duration of previous command in adaptive units (seconds, minutes, hours, days, depending on duration).
    -   Current version control branch name.
    -   Current version control worktree status using colors that match those used in `git status`:
        -   Green dot indicates staged changes.
        -   Red dot indicates unstaged changes.
        -   Blue dot indicates untracked files.
    -   Full version of current working directory (again, abbreviating `$HOME` to `~`).

Nested shells are indicated with additional prompt characters. For example, one nested shell:

![](https://raw.githubusercontent.com/wincent/wincent/media/prompt-shlvl-2.png)

Two nested shells:

![](https://raw.githubusercontent.com/wincent/wincent/media/prompt-shlvl-3.png)

Root shells are indicated with a different color prompt character and the word "root":

![](https://raw.githubusercontent.com/wincent/wincent/media/prompt-root.png)

Nesting within a root shell is indicated like this:

![](https://raw.githubusercontent.com/wincent/wincent/media/prompt-root-shlvl-2.png)

Two nested shells:

![](https://raw.githubusercontent.com/wincent/wincent/media/prompt-root-shlvl-3.png)

If the last command exited with a non-zero status (usually indicative of an error), a yellow exclamation is shown:

![](https://raw.githubusercontent.com/wincent/wincent/media/prompt-error.png)

If there are background processes, a yellow asterisk is shown:

![](https://raw.githubusercontent.com/wincent/wincent/media/prompt-bg.png)

## Dependencies

-   [tmux](https://github.com/tmux/tmux) 3.2 or later.
-   [Neovim](https://neovim.io) or [Vim](http://www.vim.org/) 8.0 or later with Ruby and Python support (although there's a reasonable amount of feature detection in order to degrade gracefully).
-   Relatively recent [Zsh](http://www.zsh.org/).
-   Relatively recent [Git](http://git-scm.com/).
-   [Clipper](https://wincent.com/products/clipper) for transparent access to the local system clipboard.
-   On macOS, [iTerm2](http://www.iterm2.com/). Additionally, only the latest version of macOS (although at the time of writing, I'm still on High Sierra) gets actively tested.
-   [Ruby](https://www.ruby-lang.org/).
-   [Adobe Source Code Pro](https://github.com/adobe-fonts/source-code-pro) or any other fixed-width font that includes the [Powerline glyphs](http://powerline.readthedocs.io/en/master/installation.html#fonts-installation).

## Platform status

| Platform                               | Status                                                                                                                                                                     |
| -------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| macOS                                  | :1st_place_medal: Currently the most tested platform, as well as the one with most aspects (because macOS 10.13 "High Sierra" is my daily driver both at home and at work) |
| Arch Linux                             | :2nd_place_medal: Less tested, fewer aspects involved, but likely to evolve in the future as I experiment with moving, at least partially, to Arch Linux                   |
| Red Hat Linux and related (eg. CentOS) | :3rd_place_medal: Less tested, fewer aspects involved, but in the past this was the distro I used full-time at work                                                        |

## Installation

### Clone

#### macOS

```sh
git clone --recursive https://github.com/wincent/wincent.git
```

#### Arch Linux

```sh
sudo pacman -Syy
sudo pacman -S git ruby tmux vim
git clone --recursive https://github.com/wincent/wincent.git
```

-   `git`: In order to clone the repo.
-   `ruby`: So that git-cipher can run (also used to build Command-T).
-   `tmux`: Just for comfort (eg. so you can see scrollback).
-   `vim`: Because the Vim aspect needs Vim (it runs `vim` to do a `:helptags` update).

##### Arch Linux on VirtualBox

If you're running Arch Linux in a VirtualBox environment in a VM named "Arch", you could increase the resolution and size of the display with a command like:

```sh
VBoxManage setextradata "Arch" "VBoxInternal2/EfiGraphicsResolution" "2560x1440"
```

### Install

> ⚠️ **WARNING:** There are _lots_ of different things that can be installed or configured (see [the "aspects" directory](./aspects)). Unless you want your machine to be exactly like mine — which is unlikely — you probably don't want to install _everything_. Maybe you don't even want everything in the ["dotfiles"](./aspects/dotfiles) and ["vim"](./aspects/vim) aspects. Please inspect the contents of each aspect before proceeding to install it; you may even be better off just looking at the configuration files and stealing the bits that you find interesting or useful (everything is [in the public domain](./LICENSE.md), unless otherwise indicated).

At the time of writing, these are the aspects, which you can expect to change over time:

-   **automator**: Scripts for use with Automator
-   **automount**: Sets up macOS's automount facility
-   **backup**: Backup scripts
-   **cron**: Sets up cron files
-   **defaults**: Sets up defaults (ie. preferences) on macOS
-   **dotfiles**: Creates symlinks in \$HOME to the dotfiles in this repo
-   **fonts**: Installs Source Code Pro font files
-   **homebrew**: Installs and updates Homebrew
-   **iterm**: Dynamic profiles for iTerm
-   **karabiner**: Configures Karabiner-Elements
-   **launchd**: Configures launchd
-   **locale**: Sets up /etc/locale.conf
-   **meta**: Tests the configuration framework
-   **node**: Installs Node.js
-   **pacman**: Installs packages via the Pacman package manager
-   **ruby**: Installs Ruby gems
-   **shell**: Sets the use shell to zsh
-   **ssh**: Manages local SSH config
-   **tampermonkey**: Sets up UserScripts
-   **terminfo**: Sets up terminfo database entries for italics and 256-color support
-   **vim**: Configures Vim

#### Examples

```sh
./install dotfiles vim      # Just install "dotfiles" and "vim" stuff.
./install dotfiles          # Just install "dotfiles".
./install dotfiles --step   # Prompt for confirmation at each step.
./install dotfiles --check  # Do a dry-run, showing what would be changed.
./install                   # Install everything.
./install --help            # Info on installing specific rol
```

This sets up a local Node environment using [n](https://github.com/tj/n), and then uses [Fig](./fig/README.md) to copy the dotfiles and configure the machine.

**Note:** Given that `~/.gitconfig` is included with these dotfiles, any local modifications or overrides that you apply should be added to `~/.gitconfig.local` instead; for example:

```sh
git config --file ~/.gitconfig.local user.name "John Doe"
git config --file ~/.gitconfig.local user.email johndoe@example.com
```

### Troubleshooting

#### General troubleshooting

There are a few useful `./install` options:

```sh
# Run in "check" (dry-run) mode.
./install --check

# Show debugging information during the run.
./install --debug

# Confirm each task before running it (--step), and begin
# execution from a specific task (--start-at-task) in a
# specific aspect ("dotfiles").
./install --step --start='make directories' dotfiles
```

### License

Unless otherwise noted, the contents of this repo are in the public domain. See the [LICENSE](LICENSE.md) for details.

### Authors

The repo is written and maintained by Greg Hurrell &lt;[greg@hurrell.net](mailto:greg@hurrell.net)&gt;. Other contributors that have submitted patches include, in alphabetical order:

-   Anton Kastritskiy
-   Joe Lencioni
-   Jonathan Wilkins
-   Mark Stenglein
-   Matthew Byrne
-   Stone C. Lasley
-   Victor Igor
-   Zac Collier

This list produced with:

    :read !git shortlog -s HEAD | grep -v 'Greg Hurrell' | cut -f 2-3 | sed -e 's/^/- /'
