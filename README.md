# "dotfiles" and system configuration

![](https://raw.githubusercontent.com/wincent/wincent/media/screenshot.png)

* Target platforms: macOS and Red Hat-like Linuxes (eg. CentOS).
* Set-up method: ~~Beautiful and intricate snowflake~~ incredibly over-engineered [Ansible](https://www.ansible.com/) orchestration.
* Visible in the screenshot:
  * [Tomorrow Night](https://chriskempson.github.io/base16) color scheme.
  * [Adobe Source Code Pro](https://github.com/adobe-fonts/source-code-pro) (Light) font.
  * Vim, running inside tmux, inside iTerm2, on macOS "El Capitan".

## Features

### Dotfiles

[A set of dotfiles](https://github.com/wincent/wincent/tree/master/roles/dotfiles/files) that I've been tweaking and twiddling since the early 2000s ([under version control](https://github.com/wincent/wincent/commit/61a7e2a830edb7) since 2009). Characteristics include:

* Sane Vim pasting via bracketed paste mode.
* Write access to local clipboard from local and remote hosts, inside and outside of tmux (via [Clipper](https://github.com/wincent/clipper)).
* Full mouse support (pane/split resizing, scrolling, text selection) in Vim and tmux.
* Focus/lost events for Vim inside tmux.
* Cursor shape toggles on entering Vim.
* Italics in the terminal.
* Bundles a (not-excessive) number of [useful Vim plug-ins](https://github.com/wincent/wincent/tree/master/roles/dotfiles/files/.vim/pack).
* Conservative Vim configuration (very few overrides of core functionality; most changes are unobtrusive enhancements; some additional functionality exposed via `<Leader>` and `<LocalLeader>` mappings.
* Relatively restrained Zsh config, Bash-like but with a few Zsh perks, such as right-side prompt, auto-cd hooks, command elapsed time printing and such.
* Unified color-handling (across iTerm2 and Vim) via [Base16 Shell](https://github.com/chriskempson/base16-shell).
* Encrypted versioning of files with sensitive content (via [git-cipher](https://github.com/wincent/git-cipher)).
* Comprehensive [Hammerspoon](http://www.hammerspoon.org/) [config](https://github.com/wincent/wincent/tree/master/roles/dotfiles/files/.hammerspoon).

### Homebrew

On macOS, [the `homebrew` role](https://github.com/wincent/wincent/tree/master/roles/homebrew) installs [a bunch of useful software](https://github.com/wincent/wincent/blob/master/roles/homebrew/files/Brewfile).

### Keyboard customization

On macOS, Hammerspoon is used to provide the functionality previously provided in [the `keyboard` role](https://github.com/wincent/wincent/tree/c250a81d235bef574d3a7cf2f2bb7a585bcd9686/roles/keyboard) via [Karabiner](https://pqrs.org/osx/karabiner/):

* Make Caps Lock serve as Backspace (when tapped), repeated Backspace (when pressed and held), and Left Control (when chorded with another key).
* Make Return serve as Return (when tapped), repeated Return (when pressed and held), and Right Control (when chorded with another key).
* Maps Control-I to F6 in the terminal so that it can be mapped independently from Tab in Vim.

Other functionality that *used* to come via Karabiner isn't (yet) supported because Karabiner itself doesn't support macOS Sierra, and its successor, [Karabiner-Elements](https://github.com/tekezo/Karabiner-Elements), still has a pretty primitive feature set:

* Adds a "SpaceFN" layer that can be activated by holding down Space while hitting other keys; I use this to make the cursor keys available on or near the home row in any app.
* Turn Caps Lock on by tapping both Shift keys simultaneously (turn it off by tapping either Shift key on its own).
* Makes the function keys on my external Realforce keyboard behave like the "media" keys on Apple's keyboards. F13 serves as a sticky "fn" key, and F15 as Power.

### Mutt

A number of tools are used to provide command-line access to Gmail and Office IMAP accounts.

* [mutt](http://www.mutt.org/): For reading email.
* [isync](http://isync.sourceforge.net/): For maintaining a local cache of messages for offline access.
* [notmuch](https://notmuchmail.org/): For fast search.
* [msmtp](http://msmtp.sourceforge.net/): For sending email.
* [elinks](http://elinks.or.cz/): For viewing HTML emails.
* [urlview](https://packages.debian.org/sid/misc/urlview): For opening URLs from inside mutt.
* [terminal-notifier](https://github.com/julienXX/terminal-notifier): For notifications.
* [lbdb](https://www.spinnaker.de/lbdb/): Contact autocompletion drawing from a number of sources, such as previous messages, aliases, and macOS Contacts (which can be configured to synchronize Google contacts as well).
* [reattach-to-user-name-space](https://github.com/ChrisJohnsen/tmux-MacOSX-pasteboard): So that `lbdb` can query the macOS Contacts, and `terminal-notifier` can do its thing, even inside `tmux`.
* [imapfilter](https://github.com/lefcha/imapfilter/): For filtering.
* [passage](https://github.com/wincent/passage): For mediating interaction with the macOS keychain.

In order for all this to work, a few items have to be stored in the macOS keychain:

* Four "generic" (A.K.A. "application") keychain items (that is, without protocols, only hostnames):
  * For sending mail:
    * An item with (for Gmail):
      * "Keychain Item Name": smtp.gmail.com (corresponds to the "host" field in `~/.msmtprc`).
      * "Account Name": username+mutt@example.net (corresponds to the "user" field in `~/.msmtprc`).
    * An item with (for Office):
      * "Keychain Item Name": smtp.office365.com (corresponds to the "host" field in `~/.msmtprc`).
      * "Account Name": username+mutt@example.com (corresponds to the "user" field in `~/.msmtprc`).
  * For receiving mail:
    * An item with (for Gmail):
      * "Keychain Item Name": imap.gmail.com (corresponds to the "Host" field in `~/.mbsyncrc`).
      * "Account Name": username+mutt@example.net (corresponds to the "PassCmd" field in `~/.mbsyncrc`).
    * An item with (for Office):
      * "Keychain Item Name": outlook.office365.com
      * "Account Name": username+mutt@example.com

The following Gmail-like/Vim-like bindings are configured:

* `e`: Archive (but note: leaves copy of mail in mailbox until next sync; force an immediate sync with `$`).
* `#`: Trash mail.
* `!`: Mark as spam.
* `gi`: Go to inbox.
* `ga`: Go to archive.
* `gt`: Go to sent mail.
* `gd`: Go to drafts.
* `gs`: Go to starred mail.
* `gl`: Go to a label (folder).
* `x`: Toggle selection on entry (see also `t`).
* `c`: Compose new message.
* `s`: Toggle star.
* `*a`: Select all.
* `*n`: Deselect all (mnemonic: "select none").
* `*r`: Select read messages.
* `*u`: Select unread messages.
* `Shift-U`: Mark as unread.
* `Shift-I`: Mark as read.

Standard `mutt` stuff:

* `v`: View attachments (including alternate parts for a multipart message).

Non-Gmail extensions:

* `gh`: Go to home account (mnemonic: "[g]o [h]ome!").
* `gw`: Go to work account (mnemonic: "[g]et to [w]ork!".
* `t`: Toggle selection on entire thread (see also `x`).
* `A` show alternate MIME-type in MIME-multipart messages.
* `S`: Search all using [Xapian query syntax](https://xapian.org/docs/queryparser.html):
  * `+foo`: Must include "foo".
  * `-bar`: Must not include "bar".
  * `AND`, `OR`, `NOT`, `XOR`: Self-evident.
  * `foo NEAR bar`: "foo" within 10 words of "bar" (order-independent).
  * `foo ADJ bar`: Like `NEAR`, but "foo" must appear earlier than "bar".
  * `"foo bar"`: Match entire phrase.
  * `foo*`: Match "foo", "food", "foobar" etc.
  * `subject:this`, `subject:"one two"`
  * `{from,to}:john`, `{from,to}:me@example.com`
  * `folder:Home/Home` (prefix search)
  * `date:today`, `date:7d` (and much more)
  * `is:unread`
* `\u`: Open list of URLs in message (via `urlview`).
* `b`: Toggle (mailboxes) sidebar.
* `m`: Move message(s).

To have `mailto` links open up in `mutt` in iTerm:

1. In *iTerm2* → *Preferences* → *Profiles* → *General*, create a copy of your default profile by clicking on *Other Actions...* and selecting *Duplicate Profile*.
2. Name the copy something identifying, like "Mutt".
3. Under *Command*, select the *Command* radio button and enter `/usr/bin/env MAILTO=$$URL$$ /usr/local/bin/zsh -ic "/usr/local/bin/mutt -- $MAILTO"`:
4. Under *URL Schemes* → *Schemes handled:*, select `mailto`.

Notes:

* `$$URL$$` is documented [here](https://groups.google.com/d/msg/iterm2-discuss/TFPl1D_miIU/uDVV2ZZpYWQJ).
* The convoluted use of `env` and `zsh` is required to get terminal colors working correctly.

## Dependencies

* [tmux](http://tmux.sourceforge.net/) 2.3 or later.
* [Vim](http://www.vim.org/) 8.0 or later with Ruby and Python support (although there's a reasonable amount of feature detection in order to degrade gracefully).
* Relatively recent [Zsh](http://www.zsh.org/).
* Relatively recent [Git](http://git-scm.com/).
* [Clipper](https://wincent.com/products/clipper) for transparent access to the local system clipboard.
* On macOS, [iTerm2](http://www.iterm2.com/). Additionally, only the latest version of macOS (currently Sierra) gets actively tested.
* [Python](https://www.python.org/) to perform setup via the included `install` command.
* [Ruby](https://www.ruby-lang.org/).
* [CMake](https://cmake.org/) is required for YouCompleteMe.
* [Adobe Source Code Pro](https://github.com/adobe-fonts/source-code-pro) or any other fixed-width font that includes the [Powerline glyphs](http://powerline.readthedocs.io/en/master/installation.html#fonts-installation).

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

**Warning:** Beware of the `.gitconfig`, you need to change for your user name and email address:

```sh
$ git config --global user.name "John Doe"
$ git config --global user.email johndoe@example.com
```

### Troubleshooting

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

### License

Unless otherwise noted, the contents of this repo are in the public domain. See the [LICENSE](LICENSE.md) for details.

### Authors

The repo is written and maintained by Greg Hurrell &lt;[greg@hurrell.net](mailto:greg@hurrell.net)&gt; Other contributors that have submitted patches include, in alphabetical order:

- Joe Lencioni
- Victor Igor
- Zac Collier

This list produced with:

    :read !git shortlog -s | grep -v 'Greg Hurrell' | cut -f 2-3 | sed -e 's/^/- /'
