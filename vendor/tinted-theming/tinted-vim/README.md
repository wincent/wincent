# Tinted Vim

Formerly base16-vim, but now supports multiple scheme systems, currently
[base16] and [base24], so we updated the name to reflect that.

[![Matrix Chat](https://img.shields.io/matrix/tinted-theming:matrix.org)](https://matrix.to/#/#tinted-theming:matrix.org)

Supports console [Vim], graphical Vim and [Neovim].

Over [250 themes] plus light/dark variations are available. Here are
some of our favorites:

The `classic-dark` theme:

![tinted-vim classic-dark]

The `horizon-dark` theme:

![tinted-vim horizon-dark]

The `onedark` theme:

![tinted-vim onedark]

## Usage

1. [Install](#installation) the plugin.
1. Configuration depends on your environment:

    - **24-bit Terminal or GUI Vim**

        Vimscript:

        ```vim
        set termguicolors  " Only needed for terminal vim
        colorscheme base16-ayu-dark
        ```

        Lua:

        ```lua
        vim.cmd.colorscheme('base16-ayu-dark')
        ```

    - **256 Color Terminal**

      Configure [tinted-shell]

      Vimscript:

      ```vim
      let tinted_colorspace=256
      colorscheme base16-ayu-dark " Set to same theme as your terminal theme
      ```

      Lua:

      ```lua
      vim.g.tinted_colorspace = 256
      vim.cmd.colorscheme('base16-ayu-dark')
      ```

    - **16 Color Terminal**

      With a 16 color terminal there will be less "gray" colors.
      Configure terminal with theme from [tinted-shell], [official] or [unofficial].

      Vimscript:

      ```vim
      colorscheme base16-ayu-dark  " Set to same theme as your terminal theme
      ```

      Lua:

      ```lua
      vim.cmd.colorscheme('base16-ayu-dark')
      ```

1. Check the highlights with (Neovim only):

```vim
:help tinted-vim
```

## Installation

### Lazy.nvim

```lua
{
    "tinted-theming/tinted-vim",
}
```

### Packer

```lua
use {
  "tinted-theming/tinted-vim",
  config = function()
    vim.cmd.colorscheme 'base16-ayu-dark'
  end,
}
```

### Pathogen

```sh
cd ~/.vim/bundle
git clone https://github.com/tinted-theming/tinted-vim.git
```

```vim
Plugin 'tinted-theming/tinted-vim'
```

### vim-plug

Add the following to your `~/.vimrc` file and run `PlugInstall` in Vim.

```vim
Plug 'tinted-theming/tinted-vim'
```

### Vundle

Add the following to your `~/.vimrc` file and run `PluginInstall` in Vim.

```sh
git clone https://github.com/tinted-theming/tinted-vim.git ~/.vim/bundle/tinted-vim
```

```vim
Plugin 'tinted-theming/tinted-vim'
```

#### Symlink

You can use a symlink to easily keep things updated. Update your vim
colors every time you do a `git pull` on the `tinted-vim` repo.

1. Clone `tinted-vim` somewhere:

   ```sh
   git clone git://github.com/tinted-theming/tinted-vim.git ~/projects/tinted-vim
   ```

1. Remove your old vim/nvim `colors/` directory if it exists:

   ```sh
   rm -r ~/.vim/colors # Or ~/.config/nvim/colors for Neovim
   ```

1. Symlink the colors directory:

   ```sh
   ln -s ~/projects/tinted-vim/colors/* ~/.vim/colors
   # Or for Neovim
   # ln -s ~/projects/tinted-vim/colors ~/.config/nvim/colors
   ```

### Manual

#### Vim

```sh
cd ~/.vim/colors
git clone git://github.com/tinted-theming/tinted-vim.git tinted-vim
cp tinted-vim/colors/*.vim .
```

#### Neovim

```sh
cd ~/.config/nvim/colors
git clone git://github.com/tinted-theming/tinted-vim.git tinted-vim
cp tinted-vim/colors/*.vim .
```

## Background transparency

If you're using a terminal with an opacity of `< 1`, you'll notice that
tinted-vim doesn't respect this transparency by default. You can enable
transparent backgrounds with tinted-vim by adding the following settings
to your Vim/Neovim setup.

Vimscript:

```vim
let tinted_background_transparent=1
```

Lua:

```lua
vim.g.tinted_background_transparent = 1
```

## Troubleshooting

There is a script to help troubleshoot colour issues called `colortest`
available in the [tinted-shell] repository.

If you are using a ISO-8613-3 compatible terminal ([vim docs],
[neovim docs]), and you see a green or blue line, try to enable
`termguicolors`:

```vim
set termguicolors
```

### Green line numbers

![green line numbers screenshot]

If your Vim looks like the above image you are using a 256 terminal
theme without setting `let tinted_colorspace=256` in your `~/.vimrc`.
Either set `let tinted_colorspace=256` in your `~/.vimrc` or use a non
256 terminal theme.

### Blue line numbers

![blue line numbers screenshot]

If your Vim looks like the above image you are setting `let
tinted_colorspace=256` in your `~/.vimrc` but either not running
[tinted-shell] or [tinted-shell] is not working for your terminal. Either
ensure [tinted-shell] is working by running the `colortest` available
in the [tinted-shell] repository or not setting `let
tinted_colorspace=256` in your `~/.vimrc`.

## Customization

If you want to do some local customization, you can add something like
this to your `~/.vimrc`:

```vim
" Set these to 0 to disable text styles. Default is 1
let g:tinted_bold = 0
let g:tinted_italic = 0
let g:tinted_strikethrough = 0
let g:tinted_underline = 0
let g:tinted_undercurl = 0

function! s:tinted_customize() abort
  call Tinted_Hi("MatchParen", g:tinted_gui05, g:tinted_gui03, g:tinted_cterm05, g:tinted_cterm03, "bold,italic", "")
endfunction

augroup on_change_colorschema
  autocmd!
  autocmd ColorScheme * call s:tinted_customize()
augroup END
```

## Contributing

See [CONTRIBUTING.md], which contains building and contributing
instructions.

[base16]: https://github.com/tinted-theming/home/blob/main/styling.md
[base24]: https://github.com/tinted-theming/base24/blob/main/styling.md
[Vim]: https://github.com/vim/vim
[Neovim]: https://github.com/neovim/neovim
[250 themes]: https://github.com/tinted-theming/schemes
[official]: https://github.com/tinted-theming/home#official-templates
[unofficial]: https://github.com/tinted-theming/home#unofficial-templates
[tinted-shell]: https://github.com/tinted-theming/tinted-shell
[vim docs]: https://github.com/vim/vim/blob/23c1b2b018c8121ca5fcc247e37966428bf8ca66/runtime/doc/options.txt#L7876
[neovim docs]: https://neovim.io/doc/user/options.html#'termguicolors'
[CONTRIBUTING.md]: CONTRIBUTING.md
[tinted-vim classic-dark]: screenshots/tinted-vim-screenshot-classic-dark.png
[tinted-vim horizon-dark]: screenshots/tinted-vim-screenshot-horizon-dark.png
[tinted-vim onedark]: screenshots/tinted-vim-screenshot-onedark.png
[green line numbers screenshot]: screenshots/without-tintedcolorspace-256-with-256-terminal-theme.png
[blue line numbers screenshot]: screenshots/with-tintedcolorspace-256-without-tinted-shell.png
