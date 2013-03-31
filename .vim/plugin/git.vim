function! GitJump(command)
  cexpr system("git jump " . a:command)
  cw
endfunction

command! -nargs=+ -complete=file GitJump call GitJump(<q-args>)
nnoremap <leader>d :GitJump diff<space>
