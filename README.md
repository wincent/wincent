# base16-nvim

Originally, this was a Lua port of [chriskempson/base16-vim](https://github.com/chriskempson/base16-vim) for [Neovim](https://github.com/neovim/neovim). As base16-vim now appears to be abandonware, the new upstream is considered to be [tinted-vim](https://github.com/tinted-theming/tinted-vim) (itself, a fork of base16-vim).

## Why?

These schemes are implemented in pure Lua, using the lowest-level API for creating highlight groups ([`vim.api.nvim_set_hl`](https://neovim.io/doc/user/api.html#nvim_set_hl())), so as to have the minimum possible impact on startup time.

## base16 or base24?

Originally, this was a [base16](https://github.com/tinted-theming/home/blob/main/styling.md) theme, but is now a [base24](https://github.com/tinted-theming/base24/blob/main/styling.md) theme (ie. with seven additional colors corresponding to the ANSI "bright" colors). For now, there are no plans to change the name.
