# Changelog

## 2017-02-09

* Use `par` to re-wrap text in Vim.

## 2017-01-19

* Get emoji working in the pager.

## 2016-12-24

* Use Markdown to send HTML email.

## 2016-12-16

* Add retry with exponential backoff to mail sync script.

## 2016-12-14

* Colorize man pages.

## 2016-12-13

* Switched from `offlineimap` to `mbsync` (in the `isync` package) for mail synchronization.

## 2016-12-12

* Added address autocompletion (via custom YouCompleteMe completer) inside Vim buffers of with filetype "mail".

## 2016-12-11

* Switched from `contacts` to `lbdb` for searching contacts.

## 2016-12-07

* Switched from `w3m` to `elinks` for viewing links within emails.

## 2016-12-02

* Added `mutt` config.

## 2016-11-30

### Enhancement

* Fine-tuned Vim startup performance from 500ms down to 150ms.

## 2016-11-29

### Breaking

* Updated base16 dependencies, which means that the existing `dark`/`light` scheme names no longer apply. Instead of `dark tomorrow` (`color dark tomorrow`) or `light tomorrow` (`color light tomorrow`), run `color tomorrow-night` and `color tomorrow`. Note that some schemes [no longer have light variants](https://github.com/chriskempson/base16/issues/42) at all. `color` continues to show currently configured scheme information and `color help` shows a list of all available colors.

## 2016-11-28

### Notice

* Removed BSD license and replaced with public domain dedication.

## 2016-11-22

### Breaking

* Replaced Karabiner configuration with custom Hammerspoon configuration, because Karabiner does not work on macOS Sierra.
  * Features that survived translation:
    * `<Capslock>` and `<Return>` retain their dual-purpose functionalities.
    * `<Tab>` and `<C-i>` can still be mapped independently in the terminal.
  * Features that have not yet been ported:
    * "SpaceFN" layer.
  * Features unlikely to be ported due to technical constraints:
    * `<Shift>` control over Caps Lock state.
  * Features that will not be ported because they can be solved by other means:
    * Remapping of YubiKey to work with Colemak.

## 2016-11-14

### Enhancement

* Add "breakpoints" to Vim statusline that reduce the amount of information displayed as window width decreases.

### Notice

* Extracted Vim macro replay functionality into a separate plug-in, [Replay](https://github.com/wincent/replay).

## 2016-11-10

### Enhancement

* Adding `<Prefix>-b` tmux binding to jump back to previous shell prompt.

## 2016-10-12

### Enhancement

* Change color of active/inactive tmux panes to make currently active pane more obvious.

## 2016-10-11

### Notice

* Manage most of the macOS preferences via the Ansible `osx_defaults` module, instead of custom Ansible `command` tasks.

## 2016-10-07

### Enhancement

* Make `C-z` run `fg` at the shell prompt.

## 2016-07-05

### Enhancement

* Bounce Dock icon when a shell command finishes running and the terminal is in the background.

## 2016-06-03

### Notice

* Set up [Clipper](https://github.com/wincent/clipper) to work via UNIX domain sockets rather than TCP ports for better security.

## 2016-05-11

### Notice

* Switched default color scheme to "tomorrow-dark" (later renamed to "tomorrow-night").

## 2016-05-09

### Enhancement

* Use `<Tab>` to toggle folds in Vim.

## 2016-05-02

### Bug fix

* Work around lengthy hangs running Ansible on macOS.

## 2016-04-29

### Notice

* Extracted within-file find-and-replace enhancements into a separate Vim plug-in, [Scalpel](https://github.com/wincent/scalpel).

## 2016-04-10

### Enhancement

* Use "Powerline" glyphs to make Vim statusline a little prettier.

### Notice

* Switch to Adobe Source Code Pro font.
