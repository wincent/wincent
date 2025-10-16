<h1 align="center">😺 vim-kitty</h1>

<p align="center">
    <i> (Neo)vim syntax highlighting for Kitty terminal configuration and
        session files. </i>
</p>

Keywords based on `v0.42.1`.

See [screenshot](https://github.com/fladson/vim-kitty/wiki) for a visual
explanation of what this plugin does.

## 📜 Filetype detection

Any `*.conf` or `*.session` files in kitty's configuration directory is
considered.

You can always add `# vim:ft=kitty` at the beginning of any file to make sure
the syntax is loaded, or you can set it temporarily with `:set ft=kitty`.

## 🚀 Installation

### [lazy.nvim](https://lazy.folke.io/)

> [!IMPORTANT]
> Lazy.nvim only works in Neovim and is the recommended method for it.

```lua
{
    "fladson/vim-kitty",
    ft = "kitty",
    tag = "*"  -- You can select a tagged version
}
```

### [vim-plug](https://github.com/junegunn/vim-plug)

> [!NOTE]
> Recommended method for Vim. Also works in Neovim but this is _Vimscript_.

```vim
" You can select a tagged version
Plug 'fladson/vim-kitty', { 'tag': '*' }
```

### Manual

For Vim:

```sh
git clone https://github.com/fladson/vim-kitty.git /tmp/vim-kitty
mkdir -p ~/.vim/after/syntax/
mv /tmp/vim-kitty/syntax/* ~/.vim/after/syntax/
rm -rf /tmp/vim-kitty
```

For Neovim:

```sh
git clone https://github.com/fladson/vim-kitty.git /tmp/vim-kitty
mkdir -p ~/.config/nvim/syntax
mkdir -p ~/.config/nvim/ftdetect
mkdir -p ~/.config/nvim/ftplugin
mv /tmp/vim-kitty/syntax/* ~/.config/nvim/syntax
mv /tmp/vim-kitty/ftdetect/kitty.vim ~/.config/nvim/ftdetect
mv /tmp/vim-kitty/ftplugin/kitty.vim ~/.config/nvim/ftplugin
rm -rf /tmp/vim-kitty
```
