autocmd BufNewFile *.md call corpus#buf_new_file()

" =============================================================================
" =============================================================================
" =============================================================================

finish

augroup Corpus
  autocmd!
  autocmd CmdlineChanged * call corpus#cmdline_changed(expand('<afile>'))
  autocmd CmdlineEnter * call corpus#cmdline_enter(expand('<afile>'))
augroup END

" This *might* work ok if in the notes directory...
command! -complete=file -nargs=1 Corpus call corpus#choose(<q-args>)
" TODO: if no args, just CC to first notes directory

" Too slow... avoid cprevious etc and call p instead
" cnoremap <silent> <C-j> <Cmd>cclose<CR><Cmd>cprevious<CR><Cmd>wincmd p<CR><Cmd>redraw<CR>
" cnoremap <silent> <C-k> <Cmd>cclose<CR><Cmd>cnext<CR><Cmd>wincmd p<CR><Cmd>redraw<CR>

cnoremap <silent> <C-j> <Cmd>call corpus#preview_next()<CR>
cnoremap <silent> <C-k> <Cmd>call corpus#preview_previous()<CR>

" TODO: enter "accepts" selection
