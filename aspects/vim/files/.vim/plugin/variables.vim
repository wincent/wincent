scriptencoding uft-8

if has('nvim')
  " Variant of statusline from plugin/statusline.vim (can't comment inline
  " with line continuation markers without Vim freaking out).
  let g:WincentQuickfixStatusline=
        \ '%7*'
        \ . '%{luaeval("' . "require'wincent.statusline'.lhs()" . '")}'
        \ . '%*'
        \ . '%4*'
        \ . ''
        \ . '\ '
        \ . '%*'
        \ . '%3*'
        \ . '%q'
        \ . '\ '
        \ . '%{get(w:,"quickfix_title","")}'
        \ . '%*'
        \ . '%<'
        \ . '\ '
        \ . '%='
        \ . '\ '
        \ . ''
        \ . '%5*'
        \ . '%{luaeval("' . "require'wincent.statusline'.rhs()" . '")}'
        \ . '%*'
else
  let g:WincentQuickfixStatusline=''
endif

call wincent#defer#defer('call wincent#variables#init()')
