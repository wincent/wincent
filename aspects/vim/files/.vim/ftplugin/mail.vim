" See also: after/ftplugin/mail.vim.

setlocal nolist

call wincent#functions#spell()

setlocal synmaxcol=0

nnoremap <buffer> j gj
nnoremap <buffer> k gk

call wincent#autocomplete#deoplete_init()
