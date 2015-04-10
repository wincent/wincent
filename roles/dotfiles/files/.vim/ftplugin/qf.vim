if exists('+cursorcolumn')
  setlocal nocursorcolumn
endif

setlocal nolist
setlocal number

" Want to set scrolloff only for the qf window, but it is a global option.
let s:original_scrolloff = &scrolloff
set scrolloff=0

augroup WincentQuickfix
  autocmd!
  autocmd BufLeave <buffer> execute 'set scrolloff=' . s:original_scrolloff
  autocmd BufEnter <buffer> set scrolloff=0 | set nocursorline
augroup END
