# "dotfiles" and system configuration

![](https://github.com/wincent/wincent/workflows/ci/badge.svg)

![](https://raw.githubusercontent.com/wincent/wincent/media/screenshot.png)

-   Target platforms: macOS and Red Hat-like Linuxes (eg. CentOS).
-   Set-up method: ~~Beautiful and intricate snowflake~~ incredibly over-engineered [Ansible](https://www.ansible.com/) orchestration.
-   Visible in the screenshot:
    -   [default-dark Base16](http://chriskempson.com/projects/base16/) color scheme (see [screenshots of other colorschemes](https://github.com/wincent/wincent/blob/media/colorschemes/README.md)).
    -   [Adobe Source Code Pro](https://github.com/adobe-fonts/source-code-pro) (Light) font.
    -   Vim, running inside tmux, inside iTerm2, on macOS "High Sierra".

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

On macOS, [the `homebrew` role](https://github.com/wincent/wincent/tree/master/roles/homebrew) installs [a bunch of useful software](https://github.com/wincent/wincent/blob/master/roles/homebrew/templates/Brewfile).

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

-   [tmux](http://tmux.sourceforge.net/) 2.3 or later.
-   [Neovim](https://neovim.io) or [Vim](http://www.vim.org/) 8.0 or later with Ruby and Python support (although there's a reasonable amount of feature detection in order to degrade gracefully).
-   Relatively recent [Zsh](http://www.zsh.org/).
-   Relatively recent [Git](http://git-scm.com/).
-   [Clipper](https://wincent.com/products/clipper) for transparent access to the local system clipboard.
-   On macOS, [iTerm2](http://www.iterm2.com/). Additionally, only the latest version of macOS (although at the time of writing, I'm still on High Sierra) gets actively tested.
-   [Ruby](https://www.ruby-lang.org/).
-   [Adobe Source Code Pro](https://github.com/adobe-fonts/source-code-pro) or any other fixed-width font that includes the [Powerline glyphs](http://powerline.readthedocs.io/en/master/installation.html#fonts-installation).

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

Or alternatively:

```sh
env http_proxy=http://fwdproxy:8080 https_proxy=http://fwdproxy:8080 git clone --recursive https://github.com/wincent/wincent
```

### Install

```sh
./install-legacy          # Installs everything on the local machine.
./install-legacy --help   # Info on installing specific roles, force-installing etc.
./install-legacy dotfiles # Just install dotfiles.
```

This sets up a local Python environment using the bundled virtualenv, bootstraps Ansible, and then uses Ansible to copy the dotfiles and configure the machine.

Again, if you're behind a firewall, you may need to make use of a proxy during the initial run:

```sh
env http_proxy=http://fwdproxy:8080 https_proxy=http://fwdproxy:8080 ./install-legacy
```

As a fallback strategy, in case the `install-legacy` script fails, you can symlink the dotfiles by hand with a command like the following:

```sh
for DOTFILE in $(find aspects/dotfiles/files -maxdepth 1 -name '.*' | tail -n +2); do
  ln -sf $PWD/$DOTFILE ~
done
```

**Note:** The `ln -sf` command will overwrite existing files, but will fail to overwrite existing directories.

**Note:** Given that `~/.gitconfig` is included with these dotfiles, any local modifications or overrides that you apply should be added to `~/.gitconfig.local` instead; for example:

```sh
git config --file ~/.gitconfig.local user.name "John Doe"
git config --file ~/.gitconfig.local user.email johndoe@example.com
```

### Troubleshooting

#### General Ansible troubleshooting

Flags passed to `./install-legacy` are propagated to the underlying Ansible invocation, which means that you can do things like:

```sh
# Run in "check" (dry-run) mode.
./install-legacy --check

# Show before-and-after delta of changes.
./install-legacy --diff

# Both of the above together.
./install-legacy --check --diff

# Show various levels of debug output.
./install-legacy --verbose
./install-legacy -vv
./install-legacy -vvv
./install-legacy -vvvv

# Confirm each task before running it (--step), and begin
# execution from a specific task (--start-at-task).
./install-legacy --step --start-at-task='dotfiles | create backup directory'
```

You can also inspect variables by adding a task that uses the "debug" module in a role:

```yaml
- name: buggy task
  stat: path="~/{{ item }}"
  register: stat_result
  with_items: '{{ dotfile_files + dotfile_templates }}'

- name: debugging bad stat info
  debug:
      var: stat_result
```

Note that for convenience, "debug" tasks have already been inserted for all variables that are `register`-ed in the existing roles, with verbosity thresholds of 2, meaning that they will be logged automatically when the install is run using `./install-legacy -vv` or more.

#### pycrypto install fails with "'gmp.h' file not found"

If pycrypto causes the install to fail at:

```sh
src/_fastmath.c:36:11: fatal error: 'gmp.h' file not found
```

due to [a missing GMP dependency](http://stackoverflow.com/questions/15375171/pycrypto-install-fatal-error-gmp-h-file-not-found), try:

```sh
brew install gmp
env "CFLAGS=-I/usr/local/include -L/usr/local/lib" pip install pycrypto
```

And then installing again:

```sh
./install-legacy --force
```

#### Broken Unicode in Vim (Linux)

If Unicode symbols appear missing or corrupted in Vim, first ensure that your terminal emulator supports UTF-8. Then, check to see if you've properly configured your system-wide UTF-8 support.

Issue this test command:

```bash
export LC_ALL=en_US.UTF-8
```

Then run `vim`. Unicode in the statusline should be working.

To persist this `LC_*` variable binding, edit your `locale` accordingly:

```bash
/etc/locale.conf

LANG=en_US.UTF-8
LC_ALL=en_US.UTF-8
```

### How this repo works

0. **2009**: Originally, the repo was just a [collection of files](https://github.com/wincent/wincent/tree/61a7e2a830edb757c59e542039131e671da8b154) with no installation script.
1. **2011-2015**: I [created a `bootstrap.rb` script](https://github.com/wincent/wincent/commit/e29b2818c487529eb4e7662a23df56445b448fe3) ([final version here](https://github.com/wincent/wincent/blob/94fb4d50243b97cd0c92a5691ac430353a5299a0/bootstrap.rb)) for performing set-up.
1. **2015**: I [briefly experimented](https://github.com/wincent/wincent/commit/4efdb1f97685bf735b068835adced059cd721096) with using a `Makefile` ([final version here](https://github.com/wincent/wincent/blob/01b37a546b92f60e659a8153067353d58805a009/Makefile)).
1. **2015-2020**: I [switched to Ansible](https://github.com/wincent/wincent/commit/375f27a6ea6fdd78fcf6614d3af5335da7a9f5ef) (completing the transition in [cd98e9aaab](https://github.com/wincent/wincent/commit/cd98e9aaab82b1983aeab839d4f28260d6e19919)).
1. **2020-present**: I started [feeling misgivings about the size of the dependency graph](https://github.com/wincent/wincent/issues/82) and in truth I was probably using less than 1% of Ansible's functionality, so moved to the current set-up, which is described below.

The goal was to replace Ansible with some handmade scripts using the smallest dependency graph possible. I original [tried](https://github.com/wincent/wincent/commit/8809a1681cfd8fd02eb40113d2485d7cadc10e4c) out [Deno](https://deno.land/) because that would enable me to use TypeScript with no dependencies outside of Deno itself, however I [gave up on that](https://github.com/wincent/wincent/commit/a213ddf69d3213882808b5c5ff0e000bcd83fe98) when I saw that editor integration was still very nascent. So I went with the following:

-   [n](https://github.com/tj/n) ([as a submodule](https://github.com/wincent/wincent/tree/master/vendor)) and some [hand-rolled Bash scripts](https://github.com/wincent/wincent/tree/master/bin) to replace [virtualenv](https://virtualenv.pypa.io/) and friends ([Python](https://www.python.org/), [pip](https://pypi.org/project/pip/)).
-   [Yarn](https://github.com/yarnpkg/yarn/) ([vendored](https://github.com/wincent/wincent/commit/26adf86d4c742390537be4dc1572f93a97bc3e68)) to install [TypeScript](https://www.typescriptlang.org/).

Beyond that, there are no dependencies outside of the [Node.js](https://nodejs.org/en/) standard library. I use [Prettier](https://prettier.io/) to format code, but I invoke it via `npx` which means the [yarn.lock](https://github.com/wincent/wincent/blob/master/yarn.lock) remains basically empty. Ansible itself is replaced by [a set of self-contained TypeScript scripts](https://github.com/wincent/wincent/tree/master/src). Instead of YAML configuration files containing "declarative" configuration peppered with Jinja template snippets containing Python and filters, we just use TypeScript for everything. Instead of [Jinja template files](https://jinja.palletsprojects.com/), we use ERB/JSP-like templates that use embedded JavaScript when necessary.

Because I need a name to refer to this "set of scripts", it's called Fig (a play on "Config"). Overall structure remains similar to Ansible, but I made some changes to better reflect the use case here. While Ansible is made to orchestrate multiple (likely remote) hosts, Fig is for configuring one local machine at a time.

| Ansible                                                                                                                         | Fig                                                                                                             |
| ------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------- |
| **Hosts:** Machines to be configured (possibly remote)                                                                          | n/a (always the current, local machine)                                                                         |
| **Groups:** Collections of hosts, so you can conveniently target multiple hosts without having to address each one individually | **Profiles:** An abstract category indicating the kind of a host (eg. "work" or "personal")                     |
| **Inventory:** A list of hosts (or groups of hosts) to be managed                                                               | n/a ("project.json" file contains map from hostname to profile to be applied)                                   |
| **Roles:** Capabilities that a host can have (eg. webserver, file-server etc)                                                   | **Aspects:** Logical groups of functionality to be configured (eg. dotfiles, terminfo etc)                      |
| **Tasks:** Operations to perform (eg. installing a package, writing a file                                                      | **Tasks:** Same as Ansible.                                                                                     |
| **Plays:** A mapping between hosts (or groups) and the tasks to be performed on them                                            | n/a (it's just a file containing tasks)                                                                         |
| **Playbooks:** Lists of plays                                                                                                   | n/a ("project.json" file contains a map from platform to the aspects that should be set up on a given platform) |
| **Tags:** Keywords that can be applied to tasks and roles, useful for selecting them to be run                                  | n/a (not needed)                                                                                                |
| **Facts:** (Inferred) attributes of hosts                                                                                       | **Attributes:** Same as Ansible, but with a better name                                                         |
| **Vars:** (Declared) values that can be assigned to groups, hosts or roles                                                      | **Vars:** Same as Ansible, but belong to profiles and aspects                                                   |
| **Modules:** Units of code that implement operations (ie. these are what tasks use to actually do the work)                     | **Operations:** Code for performing operations                                                                  |
| **Templates:** Jinja templates with embedded Python and "filters"                                                               | **Templates:** ERB templates with embedded JavaScript                                                           |
| **Files:** Raw files that can be copied using modules                                                                           | **Files:** Raw files that can be copied using operations                                                        |
| **Syntax:** YAML with interpolated Jinja syntax containing Python and variables                                                 | **Syntax:** TypeScript and (plain) JSON                                                                         |

### License

Unless otherwise noted, the contents of this repo are in the public domain. See the [LICENSE](LICENSE.md) for details.

### Authors

The repo is written and maintained by Greg Hurrell &lt;[greg@hurrell.net](mailto:greg@hurrell.net)&gt;. Other contributors that have submitted patches include, in alphabetical order:

-   Joe Lencioni
-   Jonathan Wilkins
-   Mark Stenglein
-   Matthew Byrne
-   Stone C. Lasley
-   Victor Igor
-   Zac Collier

This list produced with:

    :read !git shortlog -s HEAD | grep -v 'Greg Hurrell' | cut -f 2-3 | sed -e 's/^/- /'
