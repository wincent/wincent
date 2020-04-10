autocmd BufNewFile *.md call corpus#buf_new_file()

finish

augroup Corpus
  autocmd!
  autocmd CmdlineChanged * call corpus#cmdline_changed(expand('<afile>'))
  autocmd CmdlineEnter * call corpus#cmdline_enter(expand('<afile>'))
augroup END

" This *might* work ok if in the notes directory...
command! -complete=file -nargs=1 Corpus call corpus#choose(<q-args>)

cnoremap <silent> <Up> <Cmd>cprevious<CR><Cmd>redraw<CR>
cnoremap <silent> <Down> <Cmd>cnext<CR><Cmd>redraw<CR>
