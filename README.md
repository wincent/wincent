# "dotfiles" and system configuration

![](https://github.com/wincent/wincent/workflows/ci/badge.svg)

![](https://raw.githubusercontent.com/wincent/wincent/media/screenshot.png)

- Target platforms: macOS and Red Hat-like Linuxes (eg. CentOS).
- Set-up method: ~~Beautiful and intricate snowflake~~ incredibly over-engineered [Ansible](https://www.ansible.com/) orchestration.
- Visible in the screenshot:
  - [default-dark Base16](http://chriskempson.com/projects/base16/) color scheme.
  - [Adobe Source Code Pro](https://github.com/adobe-fonts/source-code-pro) (Light) font.
  - Vim, running inside tmux, inside iTerm2, on macOS "High Sierra".

## Features

### Dotfiles

[A set of dotfiles](https://github.com/wincent/wincent/tree/master/roles/dotfiles/files) that I've been tweaking and twiddling since the early 2000s ([under version control](https://github.com/wincent/wincent/commit/61a7e2a830edb7) since 2009). Characteristics include:

- Sane Vim pasting via bracketed paste mode.
- Write access to local clipboard from local and remote hosts, inside and outside of tmux (via [Clipper](https://github.com/wincent/clipper)).
- Full mouse support (pane/split resizing, scrolling, text selection) in Vim and tmux.
- Focus/lost events for Vim inside tmux.
- Cursor shape toggles on entering Vim.
- Italics in the terminal.
- Bundles a (not-excessive) number of [useful Vim plug-ins](https://github.com/wincent/wincent/tree/master/roles/dotfiles/files/.vim/pack).
- Conservative Vim configuration (very few overrides of core functionality; most changes are unobtrusive enhancements; some additional functionality exposed via `<Leader>` and `<LocalLeader>` mappings.
- Relatively restrained Zsh config, Bash-like but with a few Zsh perks, such as right-side prompt, auto-cd hooks, command elapsed time printing and such.
- Unified color-handling (across iTerm2 and Vim) via [Base16 Shell](https://github.com/chriskempson/base16-shell).
- Encrypted versioning of files with sensitive content (via [git-cipher](https://github.com/wincent/git-cipher)).
- Comprehensive [Hammerspoon](http://www.hammerspoon.org/) [config](https://github.com/wincent/wincent/tree/master/roles/dotfiles/files/.hammerspoon).

### Homebrew

On macOS, [the `homebrew` role](https://github.com/wincent/wincent/tree/master/roles/homebrew) installs [a bunch of useful software](https://github.com/wincent/wincent/blob/master/roles/homebrew/templates/Brewfile).

### Keyboard customization

On macOS, [Karabiner-Elements](https://github.com/tekezo/Karabiner-Elements/) is used for the following:

- Make Caps Lock serve as Backspace (when tapped) and Left Control (when chorded with another key). When held down alone, Caps Lock fires repeated Backspace events.
- Make Return serve as Return (when tapped) and Right Control (when chorded with another key). When held down alone, Return fires repeated Return events.
- Maps Control-I to F6 (only in MacVim and the terminal) so that it can be mapped independently from Tab in Vim.
- Toggle Caps Lock on by tapping both Shift keys simultaneously.
- Makes the function keys on my external Realforce keyboard behave like the "media" keys on Apple's keyboards.
- Swap Option and Command keys on my external Realforce keyboard.
- Make the "application" key (extra modifier key on right-hand side) behave as "fn" on Realforce keyboard.
- Make "pause" (at far-right of function key row) behave as "power" (effectively, sleep) on Realforce keyboard.
- Adds a "SpaceFN" layer that can be activated by holding down Space while hitting other keys; I use this to make the cursor keys available on or near the home row in any app.

### Zsh

#### Functions

- `ag`: Transparently wraps the `ag` executable so as to provide a centralized place to set defaults for that command (seeing as it has no "rc" file).
- `bounce`: bounce the macOS Dock icon if the terminal is not in the foreground.
- `color`: change terminal and Vim color scheme.
- `email`: convenience wrapper to spawn (or attach to) a tmux session running `mutt` and `mbsync`.
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

![](https://raw.githubusercontent.com/wincent/wincent/media/prompt.png)

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

### Mutt

A number of tools are used to provide command-line access to Gmail and Office IMAP accounts.

- [mutt](http://www.mutt.org/): For reading email.
- [isync](http://isync.sourceforge.net/): For maintaining a local cache of messages for offline access.
- [notmuch](https://notmuchmail.org/): For fast search.
- [msmtp](http://msmtp.sourceforge.net/): For sending email.
- [elinks](http://elinks.or.cz/): For viewing HTML emails.
- [urlview](https://packages.debian.org/sid/misc/urlview): For opening URLs from inside mutt.
- [terminal-notifier](https://github.com/julienXX/terminal-notifier): For notifications.
- [lbdb](https://www.spinnaker.de/lbdb/): Contact autocompletion drawing from a number of sources, such as previous messages, aliases, and macOS Contacts (which can be configured to synchronize Google contacts as well).
- [imapfilter](https://github.com/lefcha/imapfilter/): For filtering.
- [passage](https://github.com/wincent/passage): For mediating interaction with the macOS keychain.

In order for all this to work, a few items have to be stored in the macOS keychain:

- A "generic" (A.K.A. "application") keychain items (that is, without protocols, only hostnames):
  - "Keychain Item Name": example.net (corresponds to the "host" field in `~/.msmtprc`, and "Host" field in `~/.mbsyncrc`).
  - "Account Name": username+mutt@example.net (corresponds to the "user" field in `~/.msmtprc`, and "PassCmd" field in `~/.mbsynrc`).

The following Gmail-like/Vim-like bindings are configured:

- `e`: Archive (but note: leaves copy of mail in mailbox until next sync; force an immediate sync with `$`).
- `#`: Trash mail.
- `!`: Mark as spam.
- `gi`: Go to inbox.
- `ga`: Go to archive.
- `gt`: Go to sent mail.
- `gd`: Go to drafts.
- `gs`: Go to starred mail.
- `gl`: Go to a label (folder).
- `x`: Toggle selection on entry (see also `t`).
- `c`: Compose new message.
- `s`: Toggle star.
- `*a`: Select all.
- `*n`: Deselect all (mnemonic: "select none").
- `*r`: Select read messages.
- `*u`: Select unread messages.
- `Shift-U`: Mark as unread.
- `Shift-I`: Mark as read.

Standard `mutt` stuff:

- `v`: View attachments (including alternate parts for a multipart message).

Non-Gmail extensions:

- `t`: Toggle selection on entire thread (see also `x`).
- `A`: Show alternate MIME-type in MIME-multipart messages.
- `O`: Save original message.
- `S`: Search all using [Xapian query syntax](https://xapian.org/docs/queryparser.html) ([notmuch-specific reference documentation](https://notmuchmail.org/manpages/notmuch-search-terms-7/)):
  - `+foo`: Must include "foo".
  - `-bar`: Must not include "bar".
  - `AND`, `OR`, `NOT`, `XOR`: Self-evident.
  - `foo NEAR bar`: "foo" within 10 words of "bar" (order-independent).
  - `foo ADJ bar`: Like `NEAR`, but "foo" must appear earlier than "bar".
  - `"foo bar"`: Match entire phrase.
  - `foo*`: Match "foo", "food", "foobar" etc.
  - `subject:this`, `subject:"one two"` (two consecutive words), `subject:(one two)` (either or both words anywhere in subject), `subject:one AND subject:two` (both words anywhere in subject).
  - `subject:/regex.*/` (but note, quotes are needed for patterns containing spaces; eg. `subject:"/a b/"`).
  - `from:john`, `from:me@example.com`
  - `to:john`, `to:me@example.com`
  - `date:today`
  - `date:yesterday`
  - `date:3d` (exactly 3 days ago)
  - `date:14d..7d` (a week ago)
  - `date:10d..` (since 10 days ago)
  - `date:..3d` (until 3 days ago)
  - `date:"last week"` (preceding Monday through Sunday)
  - `date:"this week"` or `date:this_week` or `date:this-week` (Monday to present day)
  - `date:"last year"` (also works with `years`, `months`, `hours`/`hrs`, `minutes`/`mins`, `seconds`/`secs` etc).
  - `date:june`
  - `date:2018-06-01`
  - `is:{tag}`: eg. `is:unread`, `is:flagged` (ie. starred); to see all tags, run `notmuch search --output=tags '*'`:
    - `attachment`
    - `flagged`
    - `inbox` (not very meaningful as _everything_ gets this tag when indexed via `notmuch new`)
    - `replied`
    - `signed`
    - `unread`
  - `id:messageId@example.net` (search by Message-Id).
- `l`: Limit listed messages:
  - `~f bob` (from bob)
  - `~s foo` (subject contains "foo"; "Foo" would search case-sensitively)
  - `~s foo.+bar` (subject contains pattern)
  - `!~s foo` (subject does not contain "foo")
  - `~d >1m` (messages more than 1 month old)
- `\u`: Open list of URLs in message (via `urlview`).
- `b`: Toggle (mailboxes) sidebar.
- `m`: Move message(s).

Other stuff:

- `<Tab>` autocompletes addresses from the lbdb database.
- `<C-t>` autocompletes aliases.

Attachment menu bindings:

- `S`: Save all attachments.

To have `mailto` links open up in `mutt` in iTerm:

1. In _iTerm2_ → _Preferences_ → _Profiles_ → _General_, select the "Mutt" profile.
2. Under _URL Schemes_ → _Schemes handled:_, select `mailto`.

Notes:

- `$$URL$$` is documented [here](https://groups.google.com/d/msg/iterm2-discuss/TFPl1D_miIU/uDVV2ZZpYWQJ).
- The convoluted use of `env` and `zsh` is required to get terminal colors working correctly.

## Dependencies

- [tmux](http://tmux.sourceforge.net/) 2.3 or later.
- [Neovim](https://neovim.io) or [Vim](http://www.vim.org/) 8.0 or later with Ruby and Python support (although there's a reasonable amount of feature detection in order to degrade gracefully).
- Relatively recent [Zsh](http://www.zsh.org/).
- Relatively recent [Git](http://git-scm.com/).
- [Clipper](https://wincent.com/products/clipper) for transparent access to the local system clipboard.
- On macOS, [iTerm2](http://www.iterm2.com/). Additionally, only the latest version of macOS (although at the time of writing, I'm still on High Sierra) gets actively tested.
- [Python](https://www.python.org/) to perform setup via the included `install` command.
- [Ruby](https://www.ruby-lang.org/).
- [Adobe Source Code Pro](https://github.com/adobe-fonts/source-code-pro) or any other fixed-width font that includes the [Powerline glyphs](http://powerline.readthedocs.io/en/master/installation.html#fonts-installation).

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
./install          # Installs everything on the local machine.
./install --help   # Info on installing specific roles, force-installing etc.
./install dotfiles # Just install dotfiles.
```

This sets up a local Python environment using the bundled virtualenv, bootstraps Ansible, and then uses Ansible to copy the dotfiles and configure the machine.

Again, if you're behind a firewall, you may need to make use of a proxy during the initial run:

```sh
env http_proxy=http://fwdproxy:8080 https_proxy=http://fwdproxy:8080 ./install
```

As a fallback strategy, in case the `install` script fails, you can symlink the dotfiles by hand with a command like the following:

```sh
for DOTFILE in $(find roles/dotfiles/files -maxdepth 1 -name '.*' | tail -n +2); do
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

Flags passed to `./install` are propagated to the underlying Ansible invocation, which means that you can do things like:

```sh
# Run in "check" (dry-run) mode.
./install --check

# Show before-and-after delta of changes.
./install --diff

# Both of the above together.
./install --check --diff

# Show various levels of debug output.
./install --verbose
./install -vv
./install -vvv
./install -vvvv

# Confirm each task before running it (--step), and begin
# execution from a specific task (--start-at-task).
./install --step --start-at-task='dotfiles | create backup directory'
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

Note that for convenience, "debug" tasks have already been inserted for all variables that are `register`-ed in the existing roles, with verbosity thresholds of 2, meaning that they will be logged automatically when the install is run using `./install -vv` or more.

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
./install --force
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
1. **2015-2020**: I [started transitioning to Ansible](https://github.com/wincent/wincent/commit/375f27a6ea6fdd78fcf6614d3af5335da7a9f5ef) (completing the transition in [cd98e9aaab](https://github.com/wincent/wincent/commit/cd98e9aaab82b1983aeab839d4f28260d6e19919)).
1. **2020-**: I started [feeling misgivings about the size of the dependency graph](https://github.com/wincent/wincent/issues/82) and in truth I was probably using less than 1% of Ansible's functionality, so moved to the current set-up, which is described below.

The goal was to replace Ansible with some handmade scripts using the smallest dependency graph possible. I original [tried](https://github.com/wincent/wincent/commit/8809a1681cfd8fd02eb40113d2485d7cadc10e4c) out [Deno](https://deno.land/) because that would enable me to use TypeScript with no dependencies outside of Deno itself, however I [gave up on that](https://github.com/wincent/wincent/commit/a213ddf69d3213882808b5c5ff0e000bcd83fe98) when I saw that editor integration was still very nascent. So I went with the following:

- [n](https://github.com/tj/n) ([as a submodule](https://github.com/wincent/wincent/tree/master/vendor)) and some [hand-rolled Bash scripts](https://github.com/wincent/wincent/tree/master/bin) to replace [virtualenv](https://virtualenv.pypa.io/) and friends ([Python](https://www.python.org/), [pip](https://pypi.org/project/pip/)).
- [Yarn](https://github.com/yarnpkg/yarn/) to ([vendored](https://github.com/wincent/wincent/commit/26adf86d4c742390537be4dc1572f93a97bc3e68)) install [TypeScript](https://www.typescriptlang.org/).

Beyond that, there are no dependencies outside of the [Node.js](https://nodejs.org/en/) standard library. I use [Prettier](https://prettier.io/) to format code, but I invoke it via `npx` which means the [yarn.lock](https://github.com/wincent/wincent/blob/master/yarn.lock) remains basically empty. Ansible itself is replaced by [a set of self-contained TypeScript scripts](https://github.com/wincent/wincent/tree/master/src). Instead of YAML configuration files containing "declarative" configuration peppered with snippets of Python, we just use TypeScript for everything. Instead of [Jinja templates](https://jinja.palletsprojects.com/), we use ERB/JSP-like templates that use embedded JavaScript when necessary.

Because I need a name to refer to this "set of scripts", it's called Fig (a play on "Config"). Overall structure remains similar to Ansible, but I made some changes to better reflect the use case here; while Ansible is made to orchestrate multiple (likely remote) hosts, Fig is for configuring one local machine at a time.

| Ansible                                                                                                                         | Fig                                                                                         |
| ------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------- |
| **Hosts:** Machines to be configured (possibly remote)                                                                          | n/a (always the current, local machine)                                                     |
| **Groups:** Collections of hosts, so you can conveniently target multiple hosts without having to address each one individually | **Profiles:** An abstract category indicating the kind of a host (eg. "work" or "personal") |
| **Inventory:** A list of hosts (or groups of hosts) to be managed                                                               | n/a (always operating on the local host)                                                    |
| **Roles:** Capabilities that a host can have (eg. webserver, file-server etc)                                                   | **Aspects:** Logical groups of functionality to be configured (eg. dotfiles, terminfo etc)  |
| **Tasks:** Operations to perform (eg. installing a package, writing a file                                                      | **Tasks:** Same as Ansible.                                                                 |
| **Plays:** A mapping between hosts (or groups) and the tasks to be performed on them                                            | n/a (it's just a file containing tasks)                                                     |
| **Playbooks:** Lists of plays                                                                                                   | **Runbooks:** Map from platform to the aspects that should be set up on a given platform    |
| **Tags:** Keywords that can be applied to tasks and roles, useful for selecting them to be run                                  | n/a                                                                                         |
| **Facts:** (Inferred) attributes of hosts                                                                                       | **Attributes:** Same as Ansible, but with a better name                                     |
| **Vars:** (Declared) values that can be assigned to groups, hosts or roles                                                      | **Vars:** Same as Ansible, but belong to profiles and aspects                               |
| **Modules:** Units of code that implement operations (ie. these are what tasks use to actually do the work)                     | **Operations:** Code for performing operations                                              |
| **Templates:** Jinja templates with embedded Python and "filters"                                                               | **Templates:** ERB templates with embedded JavaScript                                       |
| **Files:** Raw files that can be copied using modules                                                                           | **Files:** Raw files that can be copied using operations                                    |
| **Syntax:** YAML with interpolated Python and variables                                                                         | **Syntax:** TypeScript and (plain) JSON                                                     |

### License

Unless otherwise noted, the contents of this repo are in the public domain. See the [LICENSE](LICENSE.md) for details.

### Authors

The repo is written and maintained by Greg Hurrell &lt;[greg@hurrell.net](mailto:greg@hurrell.net)&gt;. Other contributors that have submitted patches include, in alphabetical order:

- Joe Lencioni
- Jonathan Wilkins
- Mark Stenglein
- Matthew Byrne
- Stone C. Lasley
- Victor Igor
- Zac Collier

This list produced with:

    :read !git shortlog -s HEAD | grep -v 'Greg Hurrell' | cut -f 2-3 | sed -e 's/^/- /'
