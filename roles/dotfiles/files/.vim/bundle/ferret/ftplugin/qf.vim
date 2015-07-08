" Copyright 2015-present Greg Hurrell. All rights reserved.
" Licensed under the terms of the BSD 2-clause license.

setlocal nolist
if exists('+relativenumber')
  setlocal norelativenumber
endif
setlocal number

setlocal nowrap

" Want to set scrolloff only for the qf window, but it is a global option.
let s:original_scrolloff = &scrolloff
set scrolloff=0

augroup WincentQuickfix
  autocmd!
  autocmd BufLeave <buffer> execute 'set scrolloff=' . s:original_scrolloff
  autocmd BufEnter <buffer> set scrolloff=0 | setlocal nocursorline
augroup END

" Make it easy to remove entries from the quickfix listing.
nnoremap <buffer> <silent> d :set operatorfunc=ferret#private#qf_delete_motion<CR>g@
nnoremap <buffer> <silent> dd :call ferret#private#qf_delete()<CR>
vnoremap <buffer> <silent> d :call ferret#private#qf_delete()<CR>
