augroup Corpus
  autocmd!
  autocmd BufNewFile *.md call corpus#buf_new_file()
  autocmd CmdlineChanged * call corpus#cmdline_changed(expand('<afile>'))
  autocmd CmdlineEnter * call corpus#cmdline_enter(expand('<afile>'))
  autocmd CmdlineLeave * call corpus#cmdline_leave()
augroup END

command! -complete=customlist,corpus#complete -nargs=* Corpus call corpus#choose(<q-args>)

" TODO: only set these up when running :Corpus
cnoremap <silent> <C-j> <Cmd>call corpus#preview_next()<CR>
cnoremap <silent> <C-k> <Cmd>call corpus#preview_previous()<CR>

nnoremap <Plug>(Corpus) :Corpus<Space>

if !hasmapto('<Plug>(Corpus)') && maparg('<Leader>c', 'n') ==# ''
  nmap <unique> <Leader>c <Plug>(Corpus)
endif