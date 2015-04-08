command! -nargs=+ -complete=file VcsJump call vcs#jump(<q-args>)
nnoremap <leader>d :VcsJump diff<space>
