function! VcsJump(command)
  cexpr system("vcs-jump " . a:command . " 2> /dev/null")
  cw
endfunction

command! -nargs=+ -complete=file VcsJump call VcsJump(<q-args>)
nnoremap <leader>d :VcsJump diff<space>
