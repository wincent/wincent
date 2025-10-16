let s:jump_path=shellescape(simplify(fnamemodify(resolve(expand('<sfile>:p')), ':h') . '/../bin/vcs-jump'))

function! s:set_title(title)
  if has('patch-7.4.2200')
    call setqflist([], 'a', {'title': a:title})
  elseif a:type ==# 'qf'
    let w:quickfix_title=a:title
  endif
endfunction

function! vcsjump#jump(bang, command) abort
  ""
  " @option g:VcsJumpMode string "cwd"
  "
  " Controls whether vcs-jump should operate relative to Vim's current working
  " directory (when |g:VcsJumpMode| is "cwd", the default) or to the current
  " buffer (when |g:VcsJumpMode| is "buffer").
  "
  " To override the default, add this to your |.vimrc|:
  "
  " ```
  " let g:VcsJumpMode="buffer"
  " ```
  "
  " Note that you can temporarily invert the sense of this setting by running
  " |:VcsJump| with a trailing |:command-bang| (eg. `:VcsJump!`).
  "
  let l:buffer_mode=get(g:, 'VcsJumpMode', 'cwd') ==# 'buffer'
  let l:buffer_mode=a:bang ? !l:buffer_mode : l:buffer_mode
  let l:cd=l:buffer_mode ? 'cd ' . expand("%:p:h:S") . ' && ' : ''
  let l:command=join(map(split(a:command), 'shellescape(v:val)'))
  let l:original_errorformat=&errorformat
  try
    let &errorformat='%f:%l:%c:%m,%f:%l:%m'
    cexpr system(
          \   l:cd .
          \   s:jump_path . ' ' . l:command . ' 2> /dev/null'
          \ )
    call s:set_title('vcs-jump ' . a:command)
    cwindow
  finally
    let &errorformat=l:original_errorformat
  endtry
endfunction
