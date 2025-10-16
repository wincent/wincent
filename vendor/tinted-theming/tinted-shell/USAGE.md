## Profile Helper

This allows you to switch your shell theme using shell aliases. We've
since build [Tinty], a robust theme manager for base16 and base24 template
repositories. We suggest you use [Tinty] to easily switch between your
shell themes, but if you still want to use the `profile_helper` scripts,
continue reading...

### Installation

```sh
git clone https://github.com/tinted-theming/tinted-shell.git \
  $HOME/.config/tinted-theming/tinted-shell
```

### Bash/ZSH

Add following lines to your `.*rc` file:

```sh
# Tinted Shell
BASE16_SHELL_PATH="$HOME/.config/tinted-theming/tinted-shell"
[ -n "$PS1" ] && \
  [ -s "$BASE16_SHELL_PATH/profile_helper.sh" ] && \
    source "$BASE16_SHELL_PATH/profile_helper.sh"
```

### Oh my zsh

```sh
mkdir $HOME/.oh-my-zsh/plugins/tinted-shell
ln -s $HOME/.config/tinted-theming/tinted-shell/base16-shell.plugin.zsh \
  $HOME/.oh-my-zsh/plugins/tinted-shell/base16-shell.plugin.zsh
```

To use it, add `tinted-shell` to the plugins array in your `.zshrc` file:

```sh
plugins=(... tinted-shell)
```

**Note:** `base16-shell.plugin.zsh` name has been left as `base16-*` for
backwards compatibility since changing the file name will break people's
symlinks.

### Fish

Add following lines to `$HOME/.config/fish/config.fish`:

```fish
# Tinted Shell
if status --is-interactive
  set BASE16_SHELL_PATH "$HOME/.config/tinted-theming/tinted-shell"
  if test -s "$BASE16_SHELL_PATH"
    source "$BASE16_SHELL_PATH/profile_helper.fish"
  end
end
```

### Tmux

Add the following to your `.tmux.conf` file.

```tmux
set -g allow-passthrough on # Enables ANSI pass through
```

## Configuration

### Base16-Vim Users

#### Vim

The `BASE16_THEME` environment variable will set to your current
colorscheme. You can set the [base16-vim] colorscheme to the
`BASE16_THEME` environment variable by adding the following to your
`.vimrc`:

```vim
if exists('$BASE16_THEME')
    \ && (!exists('g:colors_name') 
    \ || g:colors_name != 'base16-$BASE16_THEME')
  let base16colorspace=256
  colorscheme base16-$BASE16_THEME
endif
```

Remove the `base16colorspace` line if it is not needed.

#### Neovim

If you have a lua neovim config, add the following to your `init.lua`:

```lua
local cmd = vim.cmd
local g = vim.g

local current_theme_name = os.getenv('BASE16_THEME')
if current_theme_name and g.colors_name ~= 'base16-'..current_theme_name then
  cmd('let base16colorspace=256')
  cmd('colorscheme base16-'..current_theme_name)
end
```

#### Tmux & Vim

You should source the `set_theme` scripts to initialise your Vim
theme. This is necessary due to the way TMUX sessions handle environment
variables. Without this you may run into the issue where you've changed
your theme, but Vim loads with the theme you initialised TMUX with.

**Vim**

```vim
if filereadable(expand("$HOME/.config/tinted-theming/set_theme.vim"))
  let base16colorspace=256
  source $HOME/.config/tinted-theming/set_theme.vim
endif
```

**Neovim (Lua)**

```lua
local fn = vim.fn
local cmd = vim.cmd
local set_theme_path = "$HOME/.config/tinted-theming/set_theme.lua"
local is_set_theme_file_readable = fn.filereadable(fn.expand(set_theme_path)) == 1 and true or false

if is_set_theme_file_readable then
  cmd("let base16colorspace=256")
  cmd("source " .. set_theme_path)
end
```

### Hooks

You can create your own tinted-shell hooks. These scripts will execute
every time you use tinted-shell to change your theme. When a theme is
changed via the command line alias prefixes, all executable scripts will
then be sourced. 

The hooks are used to switch the [tinted-tmux] theme. If you want to
use your own `$BASE16_SHELL_HOOKS_PATH` directory, make sure to copy the
`$BASE16_SHELL_PATH/hooks` files across and set the
`$BASE16_SHELL_HOOKS_PATH` variable before sourcing tinted-shell
profile_helper.

tinted-shell follows the [XDG Base Directory Specification]. If you have
the `$XDG_CONFIG_HOME` variable set, it will look for the `tinted-*`
cloned repos used for the shell hooks in
`$XDG_CONFIG_HOME/tinted-theming/tinted-*`.

#### Tmux

You will automatically use this hook if you have installed
[tinted-tmux] through [TPM]. tinted-shell will update (or create)
the `$HOME/.config/tinted-theming/tmux.base16.conf` (or
`$XDG_CONFIG_HOME/tinted-theming/tmux.base16.conf`) file and set the
colorscheme. You need to source this file in your `.tmux.conf`. You can
do this by adding the following to your `.tmux.conf`:

```
source-file $HOME/.config/tinted-theming/tmux.base16.conf
```

If you're using XDG, make sure to have your tmux settings installed at
`$XDG_CONFIG_HOME/tmux`.

##### XDG

If you have XDG set up, make sure your tmux setup is installed at
`$XDG_CONFIG_HOME/tmux`

```
source-file $XDG_CONFIG_HOME/tinted-theming/tmux.base16.conf
```

#### FZF

Clone [tinted-fzf] to `$HOME/.config/tinted-theming/tinted-fzf` (or
`$XDG_CONFIG_HOME/tinted-theming/tinted-fzf`). Once that is done the
hook will automatically pick that up and things will work as expected.

If you'd like to install to a different path, you can do that and set
`$BASE16_FZF_PATH` to your custom path.

#### HexChat (XChat)

1. Clone [base16-hexchat] to
   `$HOME/.config/tinted-theming/base16-hexchat` (or
   `$XDG_CONFIG_HOME/tinted-theming/base16-hexchat`). Or optionally
   install to a custom path and set `$BASE16_HEXCHAT_PATH` to that path.
2. Set the `$BASE16_HEXCHAT_COLORS_CONF_PATH` shell variable to your hexchat
   `colors.conf` file. If you don't know where that is, read the
   [base16-hexchat] repo for more information. the hook will
   automatically pick that up and things will work as expected.

Note: Restart HexChat after you've changed the theme with tinted-shell
to apply changes.

#### Delta

Add this line to your shell rc file:

```sh
export TINTED_SHELL_ENABLE_VARS=1
```

Include `delta.gitconfig` in your Git config file i.e. `~/.gitconfig`:

```gitconfig
[delta]
	syntax-theme = "ansi" # Use terminal colors
	# Rest of your delta config:
	navigate = true
	line-numbers = true
	# etc.

[include]
	# Import ${XDG_CONFIG_HOME:-$HOME/.config}/tinted-theming/delta.gitconfig.
	# It will set delta.light=(true|false):
	path = ~/.config/tinted-theming/delta.gitconfig
```

> [!NOTE]
> You may need to restart your terminal/start a new shell for the changes to take effect.

#### Sublime Merge

[base16-sublime-merge] is required to be cloned or symlinked at
`path/to/sublimemerge/Packages/base16-sublime-merge`.

The Sublime Merge package path must be added to your shell `.*rc` file.
You find find this value in Linux by opening `Sublime Merge ->
Preferences -> Browse Packages...` or on MacOS with `Sublime Merge ->
Settings... -> Browse Packages...`. Add this directory path to your
shell `.*rc` file:

```sh
export BASE16_SHELL_SUBLIMEMERGE_PACKAGE_PATH="path/to/sublime-merge/Packages"
```

Make sure
`$BASE16_SHELL_SUBLIMEMERGE_PACKAGE_PATH/User/Preferences.sublime-settings`
exists and contains the `theme` and `color_scheme` json properties. If
they don't exist, make sure the file contains them:

```json
{
    "theme": "Merge Dark.sublime-theme",
    "color_scheme": "Merge Dark.sublime-color-scheme"
}
```
This is necessary because the hook finds those properties and replaces
the values.

### Keeping your themes up to date

To update, just `git pull` wherever you've cloned `tinted-shell`. The
themes are updated on a weekly basis thanks to GitHub Actions. See the
GitHub Actions workflow in [.github/workflows/update.yml].

### Default theme

You can set the `$BASE16_THEME_DEFAULT` environment variable to the name
of a theme and it will use that theme if there is no theme currently
set. This can be useful for when you're using your dotfiles in a brand
new environment and you don't want to manually set the theme for the
first time.

For example: `$BASE16_THEME_DEFAULT="solarized-light"` 

### Default config path

You can customize where the generated configuration of this script is 
stored by setting the `$BASE16_CONFIG_PATH` environment variable before
the `profile_helper` script is loaded. This variable defaults to
`$HOME/.config/tinted-theming`.

If you are using oh-my-zsh you need to set this variable before 
`oh-my-zsh.sh` is sourced in your `.zshrc`.

[Tinted Theming]: https://github.com/tinted-theming/home
[Base16]: https://github.com/tinted-theming/home/blob/main/styling.md
[Base24]: https://github.com/tinted-theming/base24/blob/master/styling.md
[setting 256 colourspace not supported]: screenshots/setting-256-colourspace-not-supported.png
[Tinty]: https://github.com/tinted-theming/tinty
[TPM]: https://github.com/tmux-plugins/tpm
[tinted-tmux]: https://github.com/tinted-theming/tinted-tmux
[tinted-fzf]: https://github.com/tinted-theming/tinted-fzf
[base16-hexchat]: https://github.com/tinted-theming/base16-hexchat
[base16-vim]: https://github.com/tinted-theming/base16-vim
[.github/workflows/update.yml]: https://github.com/tinted-theming/base16-shell/blob/main/.github/workflows/update.yml
