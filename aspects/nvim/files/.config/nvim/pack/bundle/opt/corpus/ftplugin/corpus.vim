" Copyright 2015-present Greg Hurrell. All rights reserved.
" Licensed under the terms of the MIT license.

if !has('nvim')
  finish
endif

autocmd BufWritePost <buffer> call corpus#buf_write_post()
autocmd BufWritePre <buffer> call corpus#buf_write_pre()

nnoremap <silent> <buffer> <C-]> :call corpus#goto('n')<CR>

xnoremap <silent> <buffer> <C-]> <Esc>:call corpus#goto('v')<CR>
