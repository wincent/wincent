function! vcs#jump(command)
  cexpr system('vcs-jump ' . a:command . ' 2> /dev/null')
  cwindow
endfunction
