iTerm2 has a "[Dynamic Profiles feature](https://www.iterm2.com/documentation-dynamic-profiles.html)" that allows you to store settings as JSON outside of the macOS defaults system. Furthermore, iTerm2 will monitor the filesystem to pick up changes to the files and apply them immediately.

This is nice for version control purposes, but our principal motivation here is to have the ability to apply different configs depending on whether an external monitor is plugged in (because an external 4K display and the internal Retina display on the laptop require different font sizes in order to produce the same physical size on the screen). We [use Hammerspoon](https://github.com/wincent/wincent/tree/master/roles/dotfiles/files/.hammerspoon) to watch for screen layout changes and when they occur, overwrite the symlinks at:

- `$HOME/Library/Application Support/iTerm2/DynamicProfiles/Mutt.json` (this is the profile used for mutt windows).
- `$HOME/Library/Application Support/iTerm2/DynamicProfiles/Vim.json` (this is the profile used for `vim://` windows).
- `$HOME/Library/Application Support/iTerm2/DynamicProfiles/Wincent.json` (this is the profile used for other windows).

Overwriting the targets that the symlinks point to causes iTerm to read them and pick up the changes. The link targets are all stored in the "Sources" directory here:

- `$HOME/Library/Application Support/iTerm2/Sources/70-Vim-Retina.json` (`vim://` settings for Retina).
- `$HOME/Library/Application Support/iTerm2/Sources/40-Mutt-Retina.json` (mutt settings for Retina).
- `$HOME/Library/Application Support/iTerm2/Sources/10-Retina.json` (settings for other Retina windows).
- `$HOME/Library/Application Support/iTerm2/Sources/70-Vim-4K.json` (`vim://` settings for the 4K display).
- `$HOME/Library/Application Support/iTerm2/Sources/40-Mutt-4K.json` (mutt settings for the 4K display).
- `$HOME/Library/Application Support/iTerm2/Sources/10-4K.json` (settings for other windows on the 4K display).

But I confess now that the above is a lie. Each of those profiles also has a "parent" profile so that they can inherit common settings and only specify overrides.

- `10-4K.json` and `10-Retina.json`, for example, inherit from a file called `00-Base.json`.
- `70-Vim-4K.json` and `70-Vim-Retina.json`, inherit from `60-Vim-Base.json`.
- `40-Mutt-4K.json` and `40-Mutt-Retina.json`, inherit from `30-Mutt-Base.json`.
- `30-Mutt-Base.json` itself inherits from `00-Base.json`.

The number prefixes are there because dynamic profiles are loaded in alphabetical order. We must make sure that parent profiles are loaded before their children, so the global ordering is thus:

- `00-Base.json`
- `10-4K.json`
- `10-Retina.json`
- `30-Mutt-Base.json`
- `40-Mutt-4K.json`
- `40-Mutt-Retina.json`
- `60-Vim-Base.json`
- `70-Vim-4K.json`
- `70-Vim-Retina.json`
- `Mutt.json`
- `Vim.json`
- `Wincent.json`

The "base" parent profiles never (or rarely) actually change, and we never need to swap one of them for another by changing a symlink target, so those ones live in this dotfiles repo and we have symlinks from `$HOME/Library/Application Support/iTerm2/DynamicProfiles` directly to them in `roles/iterm/files/DynamicProfiles`.

The "Mutt.json" and "Wincent.json" profiles are just symlinks to the "real" profiles, which all live in `$HOME/Library/Application Support/iTerm2/Sources`, and from there link to the originals in `roles/iterm/files/Sources`.

## Summary

- Just symlinks; changing what these points at causes iTerm2 to switch to a different profile:
  - `Mutt.json`
  - `Vim.json`
  - `Wincent.json`
- Actual profiles; originals live in this repo and get symlinked to from the "Sources" directory in "Application Support":
  - `10-4K.json`
  - `10-Retina.json`
  - `40-Mutt-4K.json`
  - `40-Mutt-Retina.json`
  - `70-Vim-4K.json`
  - `70-Vim-Retina.json`
- Parent profiles with common settings; originals live in this repo and get symlinked to from the "Dynamic Profiles" directory in "Application Support":
  - `00-Base.json`
  - `30-Mutt-Base.json`
  - `60-Vim-Base.json`

## What this all means

- Because these are symlinks, editing the files in this repo will have no effect until the next iTerm restart (it will notice changes made by Hammerspoon to the symlink targets, but not changes to the files themselves, because the files live in a directly that it is not monitoring).
- Any edits you make to a dynamic profile from the iTerm UI are not written back to the filesystem: to update the JSON files, you must explicitly export the settings using the drop-down in the UI, and them manually merge them in here.

## A note about the `vim://` URL scheme

We use this as a shortcut for opening a new iTerm window using Vim to display a file. For example, to open `/etc/passwd` we could `open vim:///etc/passwd`. In reality the reason we want to be able to do this is to set up a Vim command (`:Vim`) to open the current file in a new Vim instance, independently of the current context (often that means outside of tmux).

This relies on `duti` as [described here](https://boinkor.net/2016/12/configuring-iterm2-for-mosh-urls/) to register `vim://` as a URL scheme and tell macOS LaunchServices that iTerm is the handler for it:

```sh
brew install duti
duti -s com.googlecode.iterm2 vim
```

And then we configure iTerm to associate a specific profile's GUID with that URL scheme:

```sh
defaults write com.googlecode.iterm2 URLHandlersByGuid -dict-add vim 18A475CE-8744-4C20-AFAE-AAEBF4F20F40
```
