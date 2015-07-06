" terminal-specific magic
let s:iterm   = exists('$ITERM_PROFILE') || exists('$ITERM_SESSION_ID') || filereadable(expand('~/.vim/.assume-iterm'))
let s:screen  = &term =~# 'screen'
let s:tmux    = exists('$TMUX')
let s:xterm   = &term =~# 'xterm'

" Change shape of cursor in insert mode in iTerm 2.
if s:iterm
  let start_insert  = "\<Esc>]50;CursorShape=1\x7"
  let end_insert    = "\<Esc>]50;CursorShape=0\x7"

  if s:tmux
    let start_insert  = terminus#private#wrap(start_insert)
    let end_insert    = terminus#private#wrap(end_insert)
  endif

  let &t_SI = start_insert
  let &t_EI = end_insert
endif

if has('mouse')
  set mouse=a
  if s:screen || s:xterm
    if has('mouse_sgr')
      set ttymouse=sgr
    else
      set ttymouse=xterm2
    endif
  endif
endif

augroup WincentTerm
  autocmd!
  autocmd FocusGained * checktime
augroup END

" enable focus reporting on entering Vim
let &t_ti .= "\e[?1004h"
" disable focus reporting on leaving Vim
let &t_te = "\e[?1004l" . &t_te

execute "set <f20>=\<Esc>[O"
execute "set <f21>=\<Esc>[I"
cnoremap <silent> <f20> <c-\>eterminus#private#focus_lost()<cr>
cnoremap <silent> <f21> <c-\>eterminus#private#focus_gained()<cr>
inoremap <silent> <f20> <c-o>:silent doautocmd FocusLost %<cr>
inoremap <silent> <f21> <c-o>:silent doautocmd FocusGained %<cr>
nnoremap <silent> <f20> :doautocmd FocusLost %<cr>
nnoremap <silent> <f21> :doautocmd FocusGained %<cr>
onoremap <silent> <f20> <Esc>:silent doautocmd FocusLost %<cr>
onoremap <silent> <f21> <Esc>:silent doautocmd FocusGained %<cr>
vnoremap <silent> <f20> <Esc>:silent doautocmd FocusLost %<cr>gv
vnoremap <silent> <f21> <Esc>:silent doautocmd FocusGained %<cr>gv

" make use of Xterm "bracketed paste mode"
" http://www.xfree86.org/current/ctlseqs.html#Bracketed%20Paste%20Mode
" http://stackoverflow.com/questions/5585129
if s:screen || s:xterm
  " enable bracketed paste mode on entering Vim
  let &t_ti .= "\e[?2004h"

  " disable bracketed paste mode on leaving Vim
  let &t_te = "\e[?2004l" . &t_te

  set pastetoggle=<Esc>[201~
  inoremap <expr> <Esc>[200~ terminus#private#paste('')
  nnoremap <expr> <Esc>[200~ terminus#private#paste('i')
  vnoremap <expr> <Esc>[200~ terminus#private#paste('c')
  cnoremap <Esc>[200~ <nop>
  cnoremap <Esc>[201~ <nop>
endif
