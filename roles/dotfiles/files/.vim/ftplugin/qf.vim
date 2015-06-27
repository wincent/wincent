if exists('+cursorcolumn')
  setlocal nocursorcolumn
endif

setlocal nolist
if exists('+relativenumber')
  setlocal norelativenumber
endif
setlocal number

" Want to set scrolloff only for the qf window, but it is a global option.
let s:original_scrolloff = &scrolloff
set scrolloff=0

augroup WincentQuickfix
  autocmd!
  autocmd BufLeave <buffer> execute 'set scrolloff=' . s:original_scrolloff
  autocmd BufEnter <buffer> set scrolloff=0 | setlocal nocursorline
augroup END

" Don't let built-in plug-in override our setting here.
let b:did_ftplugin=1
execute 'setlocal statusline=' . g:WincentQuickfixStatusline

" Make it easy to remove entries from the quickfix listing.
" TODO: distinguish between quickfix and location list
nnoremap <buffer> <silent> d :set operatorfunc=qf#delete_motion<CR>g@
nnoremap <buffer> <silent> dd :call qf#delete()<CR>
vnoremap <buffer> <silent> d :call qf#delete()<CR>
