# Vim/Neovim support for [Reason](http://reasonml.github.io)

To have the complete Vim/Neovim Reason experience, there are two plugins to install: this one, and the [language-server](https://github.com/jaredly/reason-language-server).

This one provides syntax highlight, snippets for Reason and allows related features to recognize the Reason syntax.

Language-server provides all the others (autocompletion, type hint, jump-to-definition, etc.).

## Prerequisite

You'll need either Vim with Python 3 support, or Neovim.

## This Plugin's Installation

If you are using a plugin manager, add a line such as the following to your `.vimrc` (or `~/.config/nvim/init.vim` for neovim):

```
" If using Vim-Plug (recommended. Install from https://github.com/junegunn/vim-plug)
Plug 'reasonml-editor/vim-reason-plus'

" Or, using NeoBundle
NeoBundle 'reasonml-editor/vim-reason-plus'

" Or, using Vundle
Plugin 'reasonml-editor/vim-reason-plus'
```

## Language Server Installation

See https://github.com/jaredly/reason-language-server#vim for language-server installation and configuration.

You also need to install Vim/NeoVim's [Language Client](https://github.com/autozimu/LanguageClient-neovim). Please follow its [Quick Start](https://github.com/autozimu/LanguageClient-neovim#quick-start) for configurations.

Here's a complete configuration in your `~/.vimrc` (or `~/.config/nvim/init.vim` for neovim), assuming you use the [vim-plug](https://github.com/junegunn/vim-plug) package manager.

```viml
call plug#begin('~/.vim/plugged')

Plug 'reasonml-editor/vim-reason-plus'

Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ }

" for neovim
if has('nvim')
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
" for vim 8 with python
else
  Plug 'Shougo/deoplete.nvim'
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
  " the path to python3 is obtained through executing `:echo exepath('python3')` in vim
  let g:python3_host_prog = "/absolute/path/to/python3"
endif

" nice to have
Plug '/usr/local/opt/fzf' | Plug 'junegunn/fzf.vim'

call plug#end()

let g:LanguageClient_serverCommands = {
    \ 'reason': ['/absolute/path/to/reason-language-server.exe'],
    \ }

" enable autocomplete
let g:deoplete#enable_at_startup = 1
```

To install those, do `:PlugClean`, `:PlugInstall`, `:PlugUpdate` then `:UpdateRemotePlugins` (for neovim). This may seem contrived, but folks often forget to properly setup their plugins, so we're not taking chances with the instructions here.

Reason-language-server currently only supports BuckleScript and OCaml 4.02.3 as compiler backends.
For native development using OCaml 4.03 or later, you should prefer [ocaml-language-server](https://github.com/freebroccolo/ocaml-language-server#installation-1).

## Bonus Language Server Configuration

Please follow [LanguageClient-neovim's documentation on how to configure features](https://github.com/autozimu/LanguageClient-neovim/blob/dd45e31449511152f2127fe862d955237caa130f/doc/LanguageClient.txt#L199). Here's an example configuration:

```
nnoremap <silent> gd :call LanguageClient#textDocument_definition()<cr>
nnoremap <silent> gf :call LanguageClient#textDocument_formatting()<cr>
nnoremap <silent> <cr> :call LanguageClient#textDocument_hover()<cr>
```

Now, for example, triggering `gf` in normal mode would format the code.
