augroup Corpus
  autocmd!
  autocmd CmdlineChanged * call corpus#cmdline_changed(expand('<afile>'))
  autocmd CmdlineEnter * call corpus#cmdline_enter(expand('<afile>'))
augroup END

command! -complete=customlist,corpus#complete -nargs=1 Corpus call corpus#choose(<q-args>)
