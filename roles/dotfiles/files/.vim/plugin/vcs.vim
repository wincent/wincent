command! -nargs=+ -complete=file VcsJump call wincent#vcs#jump(<q-args>)
nnoremap <Leader>d :VcsJump diff<space>
