if has('autocmd')
  augroup Corpus
    autocmd!
    autocmd BufNewFile *.md call corpus#buf_new_file()

    " TODO: don't blow up on macOS /usr/bin/vim; will need deeper fix in long term
    if exists('##CmdlineChanged')
      autocmd CmdlineChanged * call corpus#cmdline_changed(expand('<afile>'))
    endif

    autocmd CmdlineEnter * call corpus#cmdline_enter(expand('<afile>'))
    autocmd CmdlineLeave * call corpus#cmdline_leave()
  augroup END
endif

command! -complete=customlist,corpus#complete -nargs=* Corpus call corpus#choose(<q-args>)

nnoremap <Plug>(Corpus) :Corpus<Space>

if !hasmapto('<Plug>(Corpus)') && maparg('<Leader>c', 'n') ==# ''
  nmap <unique> <Leader>c <Plug>(Corpus)
endif
