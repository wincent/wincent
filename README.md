# "dotfiles" and system configuration

![CI status badge](https://github.com/wincent/wincent/workflows/ci/badge.svg)

> These dotfiles are affectionately dedicated to the vi editor originally created by Bill Joy, with whom I have spent many pleasant evenings[^1]

— Greg Hurrell, [paraphrasing Donald Knuth](https://en.wikipedia.org/wiki/The_Art_of_Computer_Programming)

## Overview

![screenshot](https://raw.githubusercontent.com/wincent/wincent/media/screenshot.png)

- Target platforms: macOS and Linux (see [Platform status](#platform-status) below).
- Set-up method: ~~Beautiful and intricate snowflake~~ an incredibly over-engineered custom configuration framework called [Fig](./fig/README.md).
- Visible in the screenshot:
  - [The "classic-dark"](https://github.com/tinted-theming/schemes/blob/spec-0.11/base16/classic-dark.yaml) color scheme (see [screenshots of other colorschemes](https://github.com/wincent/wincent/blob/media/colorschemes/README.md)).
  - [Adobe Source Code Pro](https://github.com/adobe-fonts/source-code-pro) (Light) font.
  - [Neovim](https://neovim.io), running inside [tmux](https://github.com/tmux/tmux), inside [kitty](https://sw.kovidgoyal.net/kitty/), on macOS "Sequoia".

## Features

### Dotfiles

[A set of dotfiles](https://github.com/wincent/wincent/tree/main/aspects/dotfiles/files) that I've been tweaking and twiddling since the early 2000s ([under version control](https://github.com/wincent/wincent/commit/61a7e2a830edb7) since 2009). Characteristics include:

- Sane Vim pasting via bracketed paste mode.
- Write access to local clipboard from local and remote hosts, inside and outside of tmux (via [Clipper](https://github.com/wincent/clipper)).
- Full mouse support (pane/split resizing, scrolling, text selection) in Vim and tmux.
- Focus/lost events for Vim inside tmux.
- Cursor shape toggles on entering Vim.
- Italics in the terminal.
- Bundles a (not-excessive) number of [useful Vim plug-ins](https://github.com/wincent/wincent/tree/main/aspects/nvim/files/.config/nvim/pack/bundle/opt).
- Conservative Vim configuration (very few overrides of core functionality; most changes are unobtrusive enhancements; some additional functionality exposed via `<Leader>` and `<LocalLeader>` mappings.
- Relatively restrained Zsh config, Bash-like but with a few Zsh perks, such as right-side prompt, auto-cd hooks, command elapsed time printing and such.
- Unified color-handling (across Kitty, Neovim, etc) via [tinted-theming/tinted-kitty](https://github.com/tinted-theming/tinted-kitty), [tinted-theming/tinted-shell](https://github.com/tinted-theming/tinted-shell), [tinted-theming/tinted-tmux](https://github.com/tinted-theming/tinted-tmux), [tinted-theming/tinted-vim](https://github.com/tinted-theming/tinted-vim), and [wincent/base16-nvim](https://github.com/wincent/base16-nvim).
- Encrypted versioning of files with sensitive content (via [git-cipher](https://github.com/wincent/git-cipher)).
- Comprehensive [Hammerspoon](http://www.hammerspoon.org/) [config](https://github.com/wincent/wincent/tree/main/aspects/dotfiles/files/.hammerspoon).

### Homebrew

On macOS, [the "homebrew" aspect](https://github.com/wincent/wincent/tree/main/aspects/homebrew) installs [a bunch of useful software](https://github.com/wincent/wincent/blob/main/aspects/homebrew/templates/Brewfile.erb).

### Keyboard customization

On macOS, we use [Karabiner-Elements](https://github.com/tekezo/Karabiner-Elements/), and on Linux, we use [Interception Tools](https://gitlab.com/interception/linux/tools) and a few other pieces to make the following changes:

- Make Caps Lock serve as Backspace (when tapped) and Left Control (when chorded with another key). When held down alone, Caps Lock fires repeated Backspace events.
- Make Return serve as Return (when tapped) and Right Control (when chorded with another key). When held down alone, Return fires repeated Return events.
- Toggle Caps Lock on by tapping both Shift keys simultaneously.
- Makes the function keys on my external Realforce keyboard behave like the "media" keys on Apple's keyboards.

And these only on macOS:

- Swap Option and Command keys on my external Realforce keyboard.
- Make the "application" key (extra modifier key on right-hand side) behave as "fn" on Realforce keyboard.
- Map Control-I to F6 (only in the terminal) so that it can be mapped independently from Tab in Vim[^linux].
- Make "pause" (at far-right of function key row) behave as "power" (effectively, sleep) on Realforce keyboard.
- Adds a "SpaceFN" layer that can be activated by holding down Space while hitting other keys; I use this to make the cursor keys available on or near the home row in any app.

[^linux]: This isn't needed on Linux because we can achieve the same via a Kitty configuration.

### Zsh

#### Functions

- `ag`: Transparently wraps the `ag` executable so as to provide a centralized place to set defaults for that command (seeing as it has no "rc" file).
- `bounce`: bounce the macOS Dock icon if the terminal is not in the foreground.
- `color`: change terminal and Vim color scheme.
- `fd`: "find directory" using fast `bfs` and `sk`; automatically `cd`s into the selected directory.
- `fh`: "find [in] history"; selecting a history item inserts it into the command line but does not execute it.
- `history`: overrides the (tiny) default history count.
- `jump` (aliased to `j`): to jump to hashed directories.
- `regmv`: bulk-rename files (eg. `regmv '/\.tif$/.tiff/' *`).
- `scratch`: create a random temporary scratch directory and `cd` into it.
- `tick`: moves an existing time warp (eg. `tick +1h`); see `tw` below for a description of time warp.
- `tmux`: wrapper that reattches to pre-existing sessions, or creates new ones based on the current directory name; additionally, looks for a `.tmux` file to set up windows and panes (note that the first time a given `.tmux` file is encountered the wrapper asks the user whether to trust or skip it).
- `tw` ("time warp"): overrides `GIT_AUTHOR_DATE` and `GIT_COMMITTER_DATE` (eg. `tw -1d`).

#### Prompt

Zsh is configured with the following prompt:

![Zsh prompt](https://raw.githubusercontent.com/wincent/wincent/media/prompt.png)

Visible here are:

- Concise left-hand prompt consisting of:
  - Last component of current directory (abbreviates `$HOME` to `~` if possible).
  - Prompt marker, `❯`, the "[HEAVY RIGHT-POINTING ANGLE QUOTATION MARK ORNAMENT](https://codepoints.net/U+276F)" (that's `\u276f`, or `e2 9d af` in UTF-8).
- Extended right-hand size prompt which auto-hides when necessary to make room for long commands and contains:
  - Duration of previous command in adaptive units (seconds, minutes, hours, days, depending on duration).
  - Current version control branch name.
  - Current version control worktree status using colors that match those used in `git status`:
    - Green dot indicates staged changes.
    - Red dot indicates unstaged changes.
    - Blue dot indicates untracked files.
  - Full version of current working directory (again, abbreviating `$HOME` to `~`).

Nested shells are indicated with additional prompt characters. For example, one nested shell:

![Zsh prompt with one nested shell](https://raw.githubusercontent.com/wincent/wincent/media/prompt-shlvl-2.png)

Two nested shells:

![Zsh prompt with two nested shells](https://raw.githubusercontent.com/wincent/wincent/media/prompt-shlvl-3.png)

Root shells are indicated with a different color prompt character and the word "root":

![Zsh prompt with root shell](https://raw.githubusercontent.com/wincent/wincent/media/prompt-root.png)

Nesting within a root shell is indicated like this:

![Zsh root prompt with one nested shell](https://raw.githubusercontent.com/wincent/wincent/media/prompt-root-shlvl-2.png)

Two nested shells:

![Zsh root prompt with two nested shells](https://raw.githubusercontent.com/wincent/wincent/media/prompt-root-shlvl-3.png)

If the last command exited with a non-zero status (usually indicative of an error), a yellow exclamation is shown:

![Zsh prompt showing command with non-zero exit status](https://raw.githubusercontent.com/wincent/wincent/media/prompt-error.png)

If there are background processes, a yellow asterisk is shown:

![Zsh prompt showing background proceses](https://raw.githubusercontent.com/wincent/wincent/media/prompt-bg.png)

## Dependencies

- [tmux](https://github.com/tmux/tmux) 3.2 or later.
- [Neovim](https://neovim.io) generally tracking the [latest release and sometimes the nightly](https://github.com/neovim/neovim/releases).
- Relatively recent [Zsh](http://www.zsh.org/).
- Relatively recent [Git](http://git-scm.com/).
- [Clipper](https://github.com/wincent/clipper) for transparent access to the local system clipboard.
- [Kitty](https://sw.kovidgoyal.net/kitty/).
- [Ruby](https://www.ruby-lang.org/).
- [Adobe Source Code Pro](https://github.com/adobe-fonts/source-code-pro) or any other fixed-width font that includes the [Powerline glyphs](http://powerline.readthedocs.io/en/master/installation.html#fonts-installation).

## Platform status

| Platform                               | Status                                                                                                                                            |
| -------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------- |
| macOS                                  | :1st_place_medal: Currently the most tested platform, as well as the one with most aspects (because my daily driver is macOS 15 "Sequoia")        |
| Arch Linux                             | :2nd_place_medal: Less tested, fewer aspects involved, but likely to evolve in the future as I'm using Arch Linux on my "leisure" desktop machine |
| Red Hat Linux and related (eg. CentOS) | :skull: Abandoned, but in the past (2011-2018) this was the distro I used full-time at work                                                       |

## Installation

### Clone

Development occurs on the `main` branch, but to avoid inconvenience for people who previously cloned the repo when the `master` branch was the main line, the legacy branch _is_ kept up-to-date via [a pre-push hook](./support/hooks/pre-push) (which updates the local branch) and [a post-receive hook](./support/hooks/post-receive) (which updates the remote).

#### macOS

```sh
git clone --recursive https://github.com/wincent/wincent.git
```

#### Arch Linux

```sh
sudo pacman -Syu
sudo pacman -S git ruby tmux vim
git clone --recursive https://github.com/wincent/wincent.git
```

- `git`: In order to clone the repo.
- `ruby`: So that git-cipher can run (also used to build Command-T).
- `tmux`: Just for comfort (eg. so you can see scrollback).
- `vim`: Because the `nvim` aspect needs Vim (it runs `vim` to do a `:helptags` update).

### Install

> ⚠️ **WARNING:** There are _lots_ of different things that can be installed or configured (see [the `aspects/` directory](./aspects)). Unless you want your machine to be exactly like mine — which is unlikely — you probably don't want to install _everything_. Maybe you don't even want everything in the ["dotfiles"](./aspects/dotfiles) and ["nvim"](./aspects/nvim) aspects. Please inspect the contents of each aspect before proceeding to install it; you may even be better off just looking at the configuration files and stealing the bits that you find interesting or useful (everything is [in the public domain](./LICENSE.md), unless otherwise indicated).

At the time of writing, these are the aspects, which you can expect to change over time (see [the `aspects/` directory](./aspects) for an up-to-date listing):

- On macOS only:
  - **automator**: Scripts for use with Automator
  - **automount**: Sets up macOS's automount facility
  - **backup**: Backup scripts
  - **cron**: Sets up cron files
  - **defaults**: Sets up defaults (ie. preferences) on macOS
  - **fonts**: Installs Source Code Pro font files
  - **homebrew**: Installs and updates Homebrew
  - **karabiner**: Configures Karabiner-Elements (keyboard customization).
  - **launchd**: Configures launchd
  - **nix**: Installs packages via the Nix package manager.
  - **node**: Installs Node.js
  - **ruby**: Installs Ruby gems
  - **ssh**: Manages local SSH config
  - **violentmonkey**: Sets up UserScripts
- On Linux only:
  - **aur**: Installs packages from the Arch User Repository.
  - **avahi**: Manages the Avahi zeroconf ("Bonjour") networking daemon.
  - **interception**: Sets up Interceptions Tools (keyboard customization).
  - **locale**: Sets up /etc/locale.conf
  - **pacman**: Installs packages via the Pacman package manager
  - **sshd**: Manages sshd.
  - **systemd**: Set up services that run from systemd
- On both macOS and Linux:
  - **dotfiles**: Creates symlinks in \$HOME to the dotfiles in this repo
  - **meta**: Tests the configuration framework
  - **shell**: Sets the use shell to zsh
  - **nvim**: Configures Neovim and Vim

#### Examples

```sh
./install dotfiles nvim     # Just install "dotfiles" and "nvim" stuff.
./install dotfiles          # Just install "dotfiles".
./install dotfiles --step   # Prompt for confirmation at each step.
./install dotfiles --check  # Do a dry-run, showing what would be changed.
./install                   # Install everything.
./install ^homebrew         # Install everything except for the "homebrew" aspect.
./install --help            # Lists all aspects, descriptions, options.
```

This sets up a local Node environment using [n](https://github.com/tj/n), and then uses [Fig](./fig/README.md) to copy the dotfiles and configure the machine.

**Note:** Given that `~/.config/git/config` is included with these dotfiles, any local modifications or overrides that you apply should be added to `~/.config/git/config.local` instead; for example:

```sh
git config --file ~/.config/git/config.local user.name "John Doe"
git config --file ~/.config/git/config.local user.email johndoe@example.com
```

### Running Neovim nightly

Occasionally I need to switch to [a nightly release of Neovim](https://github.com/neovim/neovim/releases) in order to get access to unreleased features. I do this by installing a copy of the nightly under `vendor/`; for example, on macOS:

```sh
wget https://github.com/neovim/neovim/releases/download/nightly/nvim-macos-arm64.tar.gz
sha256sum nvim-macos-arm64.tar.gz
xattr -c nvim-macos-arm64.tar.gz
tar xzvf nvim-macos-arm64.tar.gz
rm nvim-macos-arm64.tar.gz
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

#### `./install` hangs on the first run

If running on a brand new OS install where you have never used `sudo` before, `./install` may appear to hang after requesting your password. This is because `sudo` may show a "lecture"[^lecture] on first run that requires you to respond to a prompt. When running in the context of `./install`, you never see this prompt, because `sudo` is running in a subprocess, which causes the run to hang.

[^lecture]: See `man sudoers`.

To avoid this, one time only, run `sudo -v` before running `./install`.

## License

Unless otherwise noted, the contents of this repo are in the public domain. See the [LICENSE](LICENSE.md) for details.

## Authors

The repo is written and maintained by Greg Hurrell &lt;[greg@hurrell.net](mailto:greg@hurrell.net)&gt;. Other contributors that have submitted patches include, in alphabetical order:

- Anton Kastritskiy
- Hashem A. Damrah
- Joe Lencioni
- Jonathan Wilkins
- Keng Kiat Lim
- Mark Stenglein
- Matthew Byrne
- Michael Lohmann
- Stone C. Lasley
- Victor Igor
- Zac Collier

This list produced with:

    :read !git shortlog -s HEAD | grep -v 'Greg Hurrell' | cut -f 2-3 | sed -e 's/^/- /'

## Security

As of [commit ec49be762ff3](https://github.com/wincent/wincent/commit/ec49be762ff3ef0570a9bc27f972d0d1f025e3da) ("feat(dotfiles): automatically sign commits on personal machines", 2022-06-19) and [commit 97143b5d7635](https://github.com/wincent/wincent/commit/97143b5d7635db0c71bb46085db99ebb6039afa9) ("feat(dotfiles): sign commits everywhere except codespaces", 2022-06-20), I started signing most commits in this and other repos with GPG keys corresponding to my work and personal email addresses.

GitHub will label such commits with a "Verified" badge. In order to see signature information using the `git` commandline executable, you would run commands such as `git show --show-signature` and `git log --show-signature`. Note that in order to be able to actually verify these signatures you need a copy of the corresponding public keys, otherwise Git will show:

```
gpg: Signature made Mon 11 Jul 2022 11:50:35 CEST
gpg:                using RSA key B0C9C204D656540BDCDA86229F6B84B5B1E9955E
gpg:                issuer "wincent@github.com"
gpg: Can't check signature: No public key
```

Note that the key fingerprint that you see in the commit is usually a subkey, signed by a primary key, which is kept offline as described in ["GPG key rotation notes"](https://wincent.dev/wiki/GPG_key_rotation_notes). In the example above, you can search a keyserver using either the subkey fingerprint that appears in the commit ([B0C9C204D656540BDCDA86229F6B84B5B1E9955E](https://keyserver.ubuntu.com/pks/lookup?search=B0C9C204D656540BDCDA86229F6B84B5B1E9955E+&fingerprint=on&op=index)) or the primary key fingerprint ([2F4469E0C1FA72AAC0A560C962106B56923F3481](https://keyserver.ubuntu.com/pks/lookup?search=2F4469E0C1FA72AAC0A560C962106B56923F3481+&fingerprint=on&op=index)), if you happen to know it, and you'll see that _both_ keys are listed in the search result, with _all_ subkeys (not just the one you searched for) listed underneath the primary key.

You can obtain the latest and full versions of the public keys with the following:

```
# Either, download directly given the key fingerprint as shown by Git:
gpg --keyserver pgp.mit.edu --recv-key 4282ED4A05CC894D53A541C3F962DC1A1941CCC4 # greg@hurrell.net
gpg --keyserver pgp.mit.edu --recv-key CA35A4528D888CDF264D0A2A4838AEDCA8CE883C # greg.hurrell@datadoghq.com
gpg --keyserver pgp.mit.edu --recv-key 2F4469E0C1FA72AAC0A560C962106B56923F3481 # wincent@github.com

# Same, but using an alternate keyserver:
gpg --keyserver keyserver.ubuntu.com --recv-key 4282ED4A05CC894D53A541C3F962DC1A1941CCC4 # greg@hurrell.net
gpg --keyserver keyserver.ubuntu.com --recv-key CA35A4528D888CDF264D0A2A4838AEDCA8CE883C # greg.hurrell@datadoghq.com
gpg --keyserver keyserver.ubuntu.com --recv-key 2F4469E0C1FA72AAC0A560C962106B56923F3481 # wincent@github.com

# Or, chose from a list of possible matches returned by searching for an email address:
gpg --keyserver pgp.mit.edu --search-keys greg@hurrell.net
gpg --keyserver pgp.mit.edu --search-keys greg.hurrell@datadoghq.com
gpg --keyserver pgp.mit.edu --search-keys wincent@github.com

# Same, but using an alternate keyserver:
gpg --keyserver keyserver.ubuntu.com --search-keys greg@hurrell.net
gpg --keyserver keyserver.ubuntu.com --search-keys greg.hurrell@datadoghq.com
gpg --keyserver keyserver.ubuntu.com --search-keys wincent@github.com
```

You can also grab the keys from GitHub, if you trust GitHub:

```
# Merely inspect:
curl https://github.com/wincent.gpg | gpg --show-keys

# Actually import:
curl https://github.com/wincent.gpg | gpg --import
```

Once you have those, Git will instead show:

```
gpg: Signature made Mon 11 Jul 2022 12:28:32 CEST
gpg:                using RSA key B0C9C204D656540BDCDA86229F6B84B5B1E9955E
gpg:                issuer "wincent@github.com"
gpg: Good signature from "Greg Hurrell <wincent@github.com>" [unknown]
gpg: WARNING: This key is not certified with a trusted signature!
gpg:          There is no indication that the signature belongs to the owner.
Primary key fingerprint: 2F44 69E0 C1FA 72AA C0A5  60C9 6210 6B56 923F 3481
     Subkey fingerprint: B0C9 C204 D656 540B DCDA  8622 9F6B 84B5 B1E9 955E
```

What's going on here, cryptographically speaking?

- GPG keys consist of public and private parts, often referred to as public keys and private keys (together, a "key pair"). As the names suggest, the owner of the key must keep the private part secret, but the public part can be freely shared.
- Roughly speaking, "signing" something means using the private key to encrypt a hash of the contents of the document that is being signed (in this case, the "document" is a commit).
- The public key can be used to decrypt the hash, which can then be compared against the contents to confirm that they match. This is what is happening when we see `gpg: Good signature` above; it means that the public key for `Greg Hurrell <wincent@github.com>` verifies that the signature was indeed created with the corresponding private key belonging to that address.
- Because only the owner has access to the private key, only the owner can make signatures with it; but conversely, because everybody has access to the public key, anybody can verify those signatures.
- GPG keys have two additional concepts: "subkeys" are keys associated with a primary key; and "usages" describe what role those keys each play (eg. "signing", "encryption").
- In practice, the primary key is always a "signing" key, and GPG will create one "encryption" subkey by default. Users can add/remove additional subkeys and assign them usages.
- I create "signing" subkeys for making signatures and I rotate them once per year (I keep my primary key "offline" so that it can't be hacked if my machine is compromised).

So those are the cryptographic primitives. The signature is "Good" in the cryptographic sense, but why the scary "WARNING"? It's because there's a whole other layer on top of this called the "web of trust". A good signature gives us the mathematical certainty that a particular private key _was_ used to produce a given signature, but that tells us nothing about the human world that exists above and around that crypto. That is, the key was used to make the signature, but was it _me_ who used the key? Am I really the handsome Australian man living in Madrid claiming to be Greg Hurrell, or am I in fact part of a clandestine criminal organization operating from a satellite-connected submarine in the Arctic sea?

The web of trust serves to link your human-level trust relationships to the underlying digital entities. By running `gpg --edit-key $KEY` and hitting `trust`, you can explicitly record your level of trust in any given key, and you can do [things like going to "key signing parties"](https://www.gnupg.org/gph/en/manual/x547.html) and such where you can physically meet people, verify their identity by whatever means you deem appropriate, and then sign one another's public keys. The accrued effect of these actions over time is to establish a web of connections where trust is transitively applied: if you trust `A` and `A` trusts `B`, then you in turn can also trust `B`. Having said all that, how to actually go about building a useful web of trust is beyond the scope of this README, and in all my long years on the internet, I've never once gone to a key signing event or otherwise engaged in activity that would help me integrate my keys into a useful web of trust.

[^1]: The evenings were spent with [vi](https://en.wikipedia.org/wiki/Vi) derivatives, not with Bill Joy.
