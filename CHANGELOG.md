# Changelog

Noteworthy changes, as selected from `git changelog --since $LAST_DATE`.

## 2025-07-16

- Added new `--pretty` formats to Git: `default` and `changelog`.
- Added new Git alias, `git changelog`.

## 2025-07-11

- (Riggrep) Use `--engine=auto` by default (allows use of PCRE2 features, such as lookaround).

## 2025-06-16

- (Git) Set `rebase.updateRefs` to `true` (ie. behave like `git rebase --update-refs`).

## 2025-06-11

- (Neovim) Add `<Leader>ppp` mapping (prints absolute path and copies it to clipboard).

## 2025-05-29

- (Fig) Taught `file()` operation to `skip` path components.

## 2025-03-28

- (Neovim) Add simple LSP progress display.

## 2025-03-17

- (Raycast) Add "tt" (new tab) and "dt" (duplicate tab) commands.

## 2025-03-10

- Add `git resurrect`, which attempts to recover dropped stashes.

## 2025-02-25

- (Git) Sort tags by `version:refname` (ie. "1.2" now comes before "1.11"; previously, they would sort lexicographically).

## 2025-02-17

- (Neovim) Switch from [vim-clipper](https://github.com/wincent/vim-clipper) (Vimscript) to [nvim-clipper](https://github.com/wincent/nvim-clipper) (Lua).

## 2025-02-11

- (Neovim) Switch from [vim-dirvish](https://github.com/justinmk/vim-dirvish) to [oil.nvim](https://github.com/stevearc/oil.nvim).

## 2025-01-31

- (Neovim) Add `<LocalLeader>z` mapping to "zoom" current window.

## 2025-01-09

- (Neovim) Add a custom `'foldexpr'` that combines indent and marker-based folding.

## 2025-01-05

- Start using tree-titter in Neovim.

## 2025-01-03

- (Neovim) Teach [nvim-cmp](https://github.com/hrsh7th/nvim-cmp) to behave as if `cmp.ConfirmBehavior.MatchSuffix` existed ([nvim-cmp#1716](https://github.com/hrsh7th/nvim-cmp/issues/1716)).

## 2024-10-10

- Added `git recent` alias.
- Set up `yazi`.

## 2024-10-10

- (Zsh) Add binding (`^x^o`) to edit last command's output.

## 2024-10-09

- Use `interactive.singleKey` in Git config.

## 2024-08-21

- Added `bin/benchmark` script to measure shell startup time.

## 2024-08-16

- Prefer [Violentmonkey](https://violentmonkey.github.io) to [Tampermonkey](https://www.tampermonkey.net).

## 2024-08-08

- Added `git continue`.

## 2024-08-03

- (Neovim) Added mappings for resizing splits.

## 2024-07-17

- Teach Hammerspoon to cycle through more window sizes.

## 2024-06-06

- Added `git long`, counterpart to `git abbrev`.

## 2023-10-08

- Switched from [Prettier](https://prettier.io) to [dprint](https://dprint.dev) for formatting.

## 2023-10-06

- Switched default color scheme to "classic-dark".

## 2021-11-11

- [Nvim] Switched to [zen-mode.nvim](https://github.com/folke/zen-mode.nvim) (from [goyo.vim](https://github.com/junegunn/goyo.vim)).

## 2021-07-10

- [Nvim] Renamed "vim" aspect to "nvim"; after fetching, the next `./install nvim` updates the symlink from `~/.config/nvim` to point at the new location.

## 2021-07-08

- [Vim] Added `:Glow` command to show a Markdown preview in Glow.

## 2021-07-07

- [Vim] Ported Neovim's `init.vim` to `init.lua`.

## 2021-06-24

- Switched default color scheme to "bright".

## 2021-06-06

- [Vim]: Instead of `~/.config/nvim` being a symbolic link to `~/.vim`, items inside `~/.vim` now symlink to items inside `~/.config/nvim`.
- [Meta]: Switched default branch from `master` to `main` (although the `master` branch will be kept in sync to avoid breaking existing clones; see [#100](https://github.com/wincent/wincent/issues/100)).

## 2020-12-21

- [Zsh]: Added `rand` subcommand to `color` function (pull request [#95](https://github.com/wincent/wincent/pull/95) from Michael Lohmann).

## 2020-10-22

- [Zsh]: Dropped `groot` alias in favor of `git root` function.

## 2020-10-10

- [Vim]: Started ported many configuration files to Lua, optimizing for Neovim, while letting Vim degrade gracefully.

## 2020-05-02

- [Meta]: Dropped Ansible dependency.

## 2020-05-01

- [Mutt]: Remove Mutt config because I haven't used it for over a year.

## 2020-04-27

- [Git]: Preseed pager with search pattern so that "n" can be used to jump to next commit or diff file.

## 2019-10-13

- [Vim]: Switched from [tpope/vim-markdown](https://github.com/tpope/vim-markdown) to [plasticboy/vim-markdown](https://github.com/plasticboy/vim-markdown); note that because this is replacing one submodule with another of the same name you may need to remove the old submodule directory with `rm` as well as removing the corresponding config in your local `.git/config` in order for the next `git submodule update --init` to succeed.

## 2019-10-02

- [Vim]: Add `:OpenOnGitHub` command.

## 2019-09-27

- [Vim]: Add `:Typecheck` command.

## 2019-09-24

- [Vim]: Add `:Lint` command.

## 2019-09-19

- [Zsh]: Make tabs visible in `git-diff` output.

## 2019-09-14

- [Vim]: Implement "smart tab" functionality (ie. in projects that use tabs, use tabs for indentation and spacing for alignment).

## 2019-09-14

- [Zsh]: Add `git cp` alias for `git cherry-pick`.

## 2019-08-23

- [Zsh]: Add `git wd` alias for `git diff --dirstat` (mnemonic: "[w]hat(changed) [d]irectory").

## 2019-08-22

- [Vim]: Use floating preview window for LSP "hover" functionality.

## 2019-07-21

- [Vim]: Switch from javascript-typescript-langserver to typescript-language-server.

## 2019-06-26

- [Zsh]: Add `git get` alias equivalent to a `git fresh` (see below) followed by a `git merge`.

## 2019-06-17

- [Zsh]: Add `subtree` function (eg. `subtree '*.js'`, or `subtree '*.js|*.ts' src`).

## 2019-06-07

- [Vim]: Add `table` snippet for use in Markdown files.

## 2019-05-23

- [Vim]: Moved plug-in submodules into "[~/.vim/pack/bundle/opt](https://github.com/wincent/wincent/tree/master/roles/dotfiles/files/.vim/pack/bundle/opt)"

## 2019-04-26

- [Zsh]: Add `git fresh` alias for `git remote update --prune`.

## 2019-03-29

- [Zsh]: Make Shift-Tab go to previous completion.
- [Vim]: Force use of NERDTree instead of netrw when opening Vim with a directory argument.

## 2019-03-27

- [Vim]: Improve set-up for doing merge conflict resolution.

## 2019-03-08

- [Zsh]: Add `git wc` alias for `git whatchanged`.

## 2019-02-27

- [Zsh]: Add `git message` (shortcut: `git msg`) alias.

## 2019-02-15

- [Vim]: Make deoplete rank file-path matches above others.

## 2019-02-14

- [Vim]: `<S-Up>`, `<S-Down>` etc can be used to navigate with location list results.

## 2019-02-07

- [Vim]: Apply tweaks for working in repos that use tabs instead of spaces.

## 2019-01-25

- [Vim]: Make improvements for working with TypeScript.

## 2019-01-23

- [Zsh]: Add `git ff` alias for doing fast-forward merges.

## 2019-01-10

- [Vim]: Bind `<C-minus>` to `:NERDTreeFind`, to complement the existing `-` binding that does in-place directory navigation (vim-vinegar style).

## 2019-01-03

- [Vim]: `J` and `K` visual mode mappings now take a count.

## 2018-12-24

- [Zsh]: Running `color` without arguments refreshes the color scheme in the current window.

## 2018-12-18

- [Vim,Zsh]: Switched default color scheme to "default-dark".

## 2018-11-25

- [Zsh]: Overhaul prompt.

## 2018-10-20

- [Vim]: Set up [Goyo](https://github.com/junegunn/goyo.vim).

## 2018-03-21

- Set up "fn" and "power" key equivalents on external keyboard.

## 2018-03-08

- [Zsh]: Add `tw` and `tick` shell utilities.

## 2018-03-06

- [Vim]: Prevent `'spelllang'` setting from getting blown away in Markdown files.

## 2017-12-28

- Make Caps Lock and Return repeat when held down.
- Add back SpaceFN layer.
- [Vim]: Add `<LocalLeader>p` mapping to print the highlight groups that apply at the current cursor position.

## 2017-12-22

- [Vim]: Add "J"/"K" bindings to move visual selection up and down.
- [Vim]: Add convenience `wincent#debug#log()` function for debugging purposes.

## 2017-12-15

- [Mutt]: Add "O" macro to save original message (mnemonic: "[O]riginal").
- [Mutt]: Add "S" macro to save all attachments (mnemonic: "[S]ave").

## 2017-12-06

- Use iTerm dynamic profiles to change the font size when an external monitor is present.

## 2017-11-08

- [Vim]: Dump YouCompleteMe.

## 2017-11-01

- [Mutt]: Mutt now uses different configs for work and personal machines.

## 2017-10-20

- [Zsh]: Add `fzf`-powered functions for finding directories and history entries.

## 2017-06-16

- Switch to Karabiner-Elements.

## 2017-06-14

- [Zsh]: Start using zsh-autosuggestions plug-in.

## 2017-06-06

- [Vim]: Neovim is now the default `$EDITOR`.

## 2017-05-03

- [Zsh]: Prompt now shows `$SHLVL` by repeating the `$` or `#` symbol.
- [Zsh]: Prompt now indicates the presence of background jobs with a `*`.
- [Vim]: Now turns off syntax highlighting in inactive splits.

## 2017-02-09

- [Vim]: Use `par` to re-wrap text.

## 2017-01-19

- Get emoji working in the pager.

## 2016-12-24

- [Mutt]: Use Markdown to send HTML email.

## 2016-12-16

- [Mutt]: Add retry with exponential backoff to mail sync script.

## 2016-12-14

- Colorize man pages.

## 2016-12-13

- [Mutt]: Switched from `offlineimap` to `mbsync` (in the `isync` package) for mail synchronization.

## 2016-12-12

- [Mutt]: Added address autocompletion (via custom YouCompleteMe completer) inside Vim buffers of with filetype "mail".

## 2016-12-11

- [Mutt]: Switched from `contacts` to `lbdb` for searching contacts.

## 2016-12-07

- [Mutt]: Switched from `w3m` to `elinks` for viewing links within emails.

## 2016-12-02

- [Mutt]: Added `mutt` config.

## 2016-11-30

- [Vim]: Fine-tuned startup performance from 500ms down to 150ms.

## 2016-11-29

- [Vim,Zsh]: Updated base16 dependencies, which means that the existing `dark`/`light` scheme names no longer apply. Instead of `dark tomorrow` (`color dark tomorrow`) or `light tomorrow` (`color light tomorrow`), run `color tomorrow-night` and `color tomorrow`. Note that some schemes [no longer have light variants](https://github.com/chriskempson/base16/issues/42) at all. `color` continues to show currently configured scheme information and `color help` shows a list of all available colors.

## 2016-11-28

- Removed BSD license and replaced with public domain dedication.

## 2016-11-22

- Replaced Karabiner configuration with custom Hammerspoon configuration, because Karabiner does not work on macOS Sierra.
  - Features that survived translation:
    - `<Capslock>` and `<Return>` retain their dual-purpose functionalities.
    - `<Tab>` and `<C-i>` can still be mapped independently in the terminal.
  - Features that have not yet been ported:
    - "SpaceFN" layer.
  - Features unlikely to be ported due to technical constraints:
    - `<Shift>` control over Caps Lock state.
  - Features that will not be ported because they can be solved by other means:
    - Remapping of YubiKey to work with Colemak.

## 2016-11-14

- [Vim]: Add "breakpoints" to statusline that reduce the amount of information displayed as window width decreases.
- [Vim]: Extracted macro replay functionality into a separate plug-in, [Replay](https://github.com/wincent/replay).

## 2016-11-10

- [tmux]: Adding `<Prefix>-b` binding to jump back to previous shell prompt.

## 2016-10-12

- [tmux]: Change color of active/inactive panes to make currently active pane more obvious.

## 2016-10-11

- Manage most of the macOS preferences via the Ansible `osx_defaults` module, instead of custom Ansible `command` tasks.

## 2016-10-07

- [Zsh]: Make `C-z` run `fg` at the shell prompt.

## 2016-07-05

- [Zsh]: Bounce Dock icon when a shell command finishes running and the terminal is in the background.

## 2016-06-03

- Set up [Clipper](https://github.com/wincent/clipper) to work via UNIX domain sockets rather than TCP ports for better security.

## 2016-05-11

- [Vim,Zsh]: Switched default color scheme to "tomorrow-dark" (later renamed to "tomorrow-night").

## 2016-05-09

- [Vim]: Use `<Tab>` to toggle folds.

## 2016-05-02

- Work around lengthy hangs running Ansible on macOS.

## 2016-04-29

- [Vim]: Extracted within-file find-and-replace enhancements into a separate plug-in, [Scalpel](https://github.com/wincent/scalpel).

## 2016-04-10

- [Vim]: Use "Powerline" glyphs to make statusline a little prettier.
- Switch to Adobe Source Code Pro font.

## Older changes

- Please see `git log --until=2016-04-10`, which should show around 1,500 commits dating as far back as May 2009.
