function! wincent#vcs#jump(command) abort
  cexpr system('vcs-jump ' . a:command . ' 2> /dev/null')
  cwindow
endfunction
