let s:jump_path=shellescape(simplify(fnamemodify(resolve(expand('<sfile>:p')), ':h') . '/../bin/vcs-jump'))

function! vcsjump#jump(command) abort
  cexpr system(s:jump_path . ' ' . a:command . ' 2> /dev/null')
  cwindow
endfunction
