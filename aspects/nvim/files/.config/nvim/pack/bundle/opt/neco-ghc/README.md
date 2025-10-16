# neco-ghc: ghc-mod/hhpc completion for neocomplcache/neocomplete/deoplete

A completion plugin for Haskell, using ghc-mod or hhpc

## What is neco-ghc

This plugin supports the following completion.

* pragma
    ![](http://cache.gyazo.com/c922e323be7dbed9aa70b2bac62be45e.png)
* language
    ![](http://cache.gyazo.com/9df4aa3cf06fc07495d6dd67a4d07cc4.png)
* importing a module
    ![](http://cache.gyazo.com/17a8bf08f3a6d5e123346f5f1c74c5f9.png)
* importing a function of a module
    ![](http://cache.gyazo.com/d3698892a40ffb8e4bef970a02198715.png)
* function based on importing modules
    ![](http://cache.gyazo.com/bc168a8aad5f38c6a83b8aa1b0fb14f6.png)

neco-ghc was originally implemented by @eagletmt on July 25, 2010, and then
ujihisa added some new features.

## Install

* Install the ghc-mod package by `stack install ghc-mod` or `cabal install
  ghc-mod` OR install the hhp package by `stack install hhp` or
  `cabal install hhp`
* Unarchive neco-ghc and put it into a dir of your &rtp.

Note: If you use ghc-mod 5.4, you should use ghc-mod 5.5+.
Because, ghc-mod 5.5 fixes the rootdir problem.

https://github.com/DanielG/ghc-mod/issues/665

## Usage

neco-ghc provides `necoghc#omnifunc` for omni-completion.
I recommend adding the following in your ~/.vim/ftplugin/haskell.vim.

```vim
" Disable haskell-vim omnifunc
let g:haskellmode_completion_ghc = 0
autocmd FileType haskell setlocal omnifunc=necoghc#omnifunc
```

See `:help compl-omni` for details on omni-completion.

### Completion engines
This plugin can be used as a source of
[neocomplete.vim](https://github.com/Shougo/neocomplete.vim) or
[neocomplcache.vim](https://github.com/Shougo/neocomplcache.vim) or
[deoplete.nvim](https://github.com/Shougo/deoplete.nvim).
You can enjoy auto-completions without any specific configuration.

This plugin also should work with [YouCompleteMe](https://github.com/Valloric/YouCompleteMe).
To enable auto-completions, you have to add the following setting.

```vim
let g:ycm_semantic_triggers = {'haskell' : ['.']}
```

## Options
### `g:necoghc_enable_detailed_browse`
Default: 0

Show detailed information (type) of symbols.
You can enable it by adding `let g:necoghc_enable_detailed_browse = 1` in your vimrc.
While it is quite useful, it will take longer boot time.

This feature was introduced in ghc-mod 1.11.5.

![](http://cache.gyazo.com/f3d2c097475021615581822eee8cb6fd.png)

### `g:necoghc_debug`
Default: 0

Show error message if ghc-mod/hhpc command fails.
Usually it will be noisy if `ghc-mod browse Your.Project.Module` always 
fails.
Use this flag only if you have some trouble.

### `g:necoghc_use_stack`
Default: 0

Allow using stack's own ghc-mod/hhpc.
If you are using ghc-mod, it will change direct `ghc-mod` mod calls to `stack
exec --no-stack-exe ghc-mod --` instead. The same goes for hhpc.
Use this flag if your globally installed ghc-mod/hhpc doesn't work properly with your
stack projects.

## Troubleshoot

### Q: neco-ghc does not work

Check the $PATH variable in vim contains the path to your ghc-mod/hhpc command.
Or you can execute `:NecoGhcDiagnostics` command for debug.

### Q: Completion isn't working for local functions or modules

https://github.com/eagletmt/neco-ghc/issues/44

It's a limitation of ghc-mod.
ghc-mod can show symbols of installed modules only.
ghc-mod cannot show symbols of developing modules or current source file.

## License

[BSD3 License](http://www.opensource.org/licenses/BSD-3-Clause), the same license as ghc-mod.
