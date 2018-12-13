command! -nargs=* -complete=file Preview call wincent#commands#preview(<f-args>)

command! LSP packadd LanguageClient-neovim | LanguageClientStart
