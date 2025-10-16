![git-cipher](https://raw.github.com/wincent/git-cipher/media/git-cipher.png)

# Introduction

git-cipher is a tool for encrypting sensitive files for storage in a public Git repo.

> :warning: This documentation refers to version 2.0 of git-cipher, which is a Node.js package and a complete rewrite from version 1.0, which was a Ruby script and used a different encryption protocol.
>
> For differences between version 1.0 and 2.0, please see [UPGRADING](UPGRADING.md). For more on version 1.0, please see [the `1-x-release` branch](https://github.com/wincent/git-cipher/tree/1-x-release).

## Usage

```sh
git cipher init
git cipher unlock
git cipher add
git cipher ls
git cipher lock
git cipher help
```

## Commands

- [`git cipher add`](docs/git-cipher-add.md)
- [`git cipher clean`](docs/git-cipher-clean.md)
- [`git cipher demo`](docs/git-cipher-demo.md)
- [`git cipher diff`](docs/git-cipher-diff.md)
- [`git cipher help`](docs/git-cipher-help.md)
- [`git cipher hook`](docs/git-cipher-hook.md)
- [`git cipher init`](docs/git-cipher-init.md)
- [`git cipher is-encrypted`](docs/git-cipher-is-encrypted.md)
- [`git cipher lock`](docs/git-cipher-lock.md)
- [`git cipher log`](docs/git-cipher-log.md)
- [`git cipher ls`](docs/git-cipher-ls.md)
- [`git cipher merge`](docs/git-cipher-merge.md)
- [`git cipher show`](docs/git-cipher-show.md)
- [`git cipher smudge`](docs/git-cipher-smudge.md)
- [`git cipher textconv`](docs/git-cipher-textconv.md)
- [`git cipher unlock`](docs/git-cipher-unlock.md)

## How it works

A brief summary follows — for a detailed description, see [PROTOCOL](PROTOCOL.md).

git-cipher generates secrets that are used to encrypt and decrypt files in the Git repository. In this document we call these "managed files". The secrets are in turn encrypted using GnuPG and stored in the repository itself. Running `git-cipher unlock` makes these secrets available in the current repository and uses them to decrypt any encrypted files (provided the person running the unlock command has the appropriate GnuPG private key). Conversely `git-cipher lock` removes the local copy of the secrets (while leaving the encrypted copy of the secrets intact) and replaces any decrypted files with their encrypted equivalents.

Files are added to the list of managed files with `git-cipher add`. These are added to the `.gitattributes` file and instruct Git to use git-cipher to transparently encrypt their contents when they are committed, and decrypt them when they are checked out. This is done using Git's "clean" and "smudge" filtering mechanism. A "textconv" filter is used to show plaintext diffs corresponding to changes made to encrypted files. A merge driver is used to facilitate merging encrypted files (by decrypting them, merging them, then encrypting the result).

## Installation

**Note:** If you install the `git-cipher` executable somewhere in your `$PATH`, Git will treat it as a subcommand, which means you can invoke it as `git cipher`. Otherwise, you will have to provide the full path to the `git-cipher` executable.

### Installing the external prerequisites (Git, GnuPG)

To install the external prerequisites, use your preferred method. For example, on macOS you might choose to use [Homebrew](http://brew.sh/):

```sh
brew install git gnupg gpg-agent
```

### Installing `git-cipher` globally

```
npm install -g git-cipher
```

**NOTE:** `git-cipher` has no runtime npm dependencies (it does have `devDependencies`, however).

### Installing `git-cipher` as a submodule inside another Git repository

If you install the git-cipher repo as a submodule inside another Git repository, you can use the included `bin/git-cipher` wrapper script to invoke the copy of `git-cipher` contained in the submodule. For an example of this, see [my dotfiles repo](https://github.com/wincent/wincent), which embeds `git-cipher` under [the `vendor/` directory](https://github.com/wincent/wincent/tree/main/vendor). You could add a submodule like this as follows:

```
mkdir -p vendor
git submodule add --name git-cipher https://github.com/wincent/git-cipher vendor/git-cipher
```

## Configuration

## Usage on Arch Linux

For most of the lifetime of `git-cipher`, I've been using it on macOS, where everything works pretty much seamlessly out of the box, especially since moving to GnuPG v2 (see [commit fd4c78aeb9d11](https://github.com/wincent/git-cipher/commit/fd4c78aeb9d11d44c7107e6a2857f0c41e0b3887) for more details of how things were streamlined by v2). On Arch Linux, I have found that I needed to do a bit of additional manual set-up.

The goal is to cache the secret key in the GPG agent so that you don't have to re-enter the password for every file.

First of all, to find out the "keygrip" of the secret key:

- `gpg --with-keygrip -K` (lists all secret keys)
- `gpg --fingerprint --with-keygrip greg@hurrell.net` (lists a specific key; [source](https://unix.stackexchange.com/a/342461/140622))

Once you have the keygrip (eg. a string like `0551973D09...`), you can allow it to be added as a "preset" passphrase (ie. cache it in the agent for the duration of the session). To achieve this, the following line:

```
allow-preset-passphrase
```

must be present in the `~/.gnupg/gpg-agent.conf` file.

You then need to tell GnuPG how to prompt for a password using a "pin helper". You can see which helpers are available with:

```sh
pacman -Ql pinentry | grep /usr/bin/
```

That will produce a list similar to:

```
pinentry /usr/bin/
pinentry /usr/bin/pinentry
pinentry /usr/bin/pinentry-curses
pinentry /usr/bin/pinentry-emacs
pinentry /usr/bin/pinentry-gnome3
pinentry /usr/bin/pinentry-gtk-2
pinentry /usr/bin/pinentry-qt
pinentry /usr/bin/pinentry-tty
```

Configure one to be used by adding to `~/.gnupg/gpg-agent.conf`:

```
pinentry-program /usr/bin/pinentry-curses
```

After making any changes, [reload the agent](https://wiki.archlinux.org/title/GnuPG#gpg-agent):

```sh
gpg-connect-agent reloadagent /bye
```

You can confirm which keys are known to the agent like so:

```sh
gpg-connect-agent 'keyinfo --list' /bye
```

Which will show a list like:

```
S KEYINFO 9BB6077848... D - - - P - - -
S KEYINFO A05D018ED6... D - - - P - - -
S KEYINFO 26CA5BE9E3... D - - - P - - -
S KEYINFO 4435E5FDCC... D - - - P - - -
S KEYINFO 0551973D09... D - - - P - - -
S KEYINFO 2529B67D84... D - - - P - - -
```

A `1` before the `P` shows that the key is [cached in the agent](https://unix.stackexchange.com/a/467062/140622), which means that none of the keys in the example list above are actually cached.

To actually cache the key, you can run:

```sh
/usr/lib/gnupg/gpg-preset-passphrase --preset 0551973D09...
```

If you redo the `keyinfo --list` operation, you should now see the expected `1`:

```
S KEYINFO 9BB6077848... D - - - P - - -
S KEYINFO A05D018ED6... D - - - P - - -
S KEYINFO 26CA5BE9E3... D - - - P - - -
S KEYINFO 4435E5FDCC... D - - - P - - -
S KEYINFO 0551973D09... D - - 1 P - - -
S KEYINFO 2529B67D84... D - - - P - - -
```

## Tips

You may see prompts like the following, depending on the trust level of your signing key:

```Text
It is NOT certain that the key belongs to the person named
in the user ID.  If you *really* know what you are doing,
you may answer the next question with yes.
```

You can avoid these prompts by setting the trust level to "ultimate" like this:

```sh
gpg --edit-key greg@hurrell.net # or $GPG_USER
> trust
> quit
```

## Author

`git-cipher` was hacked together by Greg Hurrell (<greg@hurrell.net>).
