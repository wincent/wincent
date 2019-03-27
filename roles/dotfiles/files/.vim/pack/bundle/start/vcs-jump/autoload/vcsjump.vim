let s:jump_path=shellescape(simplify(fnamemodify(resolve(expand('<sfile>:p')), ':h') . '/../bin/vcs-jump'))

function! vcsjump#jump(command) abort
  let l:command=join(map(split(a:command), 'shellescape(v:val)'))
  cexpr system(s:jump_path . ' ' . l:command . ' 2> /dev/null')
  cwindow
endfunction
