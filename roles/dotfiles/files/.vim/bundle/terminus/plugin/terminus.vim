" Copyright 2015-present Greg Hurrell. All rights reserved.
" Licensed under the terms of the BSD 2-clause license.

" Provide users with means to prevent loading, as recommended in `:h
" write-plugin`.
if exists('g:TerminusLoaded') || &compatible || v:version < 700
  finish
endif
let g:LoupeLoaded=1

" Temporarily set 'cpoptions' to Vim default as per `:h use-cpo-save`.
let s:cpoptions=&cpoptions
set cpoptions&vim

set autoread " if not changed in Vim, automatically pick up changes after "git checkout" etc
if &ttimeoutlen == -1 && &timeoutlen > 50 || &ttimeoutlen > 50
  set ttimeoutlen=50 " speed up O etc in the Terminal
endif

let s:iterm=exists('$ITERM_PROFILE') || exists('$ITERM_SESSION_ID') || exists('g:TerminusAssumeITerm') || filereadable(expand('~/.vim/.assume-iterm'))
let s:screen=&term =~# 'screen'
let s:tmux=exists('$TMUX')
let s:xterm=&term =~# 'xterm'

" Change shape of cursor in insert mode in iTerm 2.
let s:shape=exists('g:TerminusCursorShape') ? g:TerminusCursorShape : 1
if s:shape
  if s:iterm
    let s:start_insert="\<Esc>]50;CursorShape=1\x7"
    let s:end_insert="\<Esc>]50;CursorShape=0\x7"

    if s:tmux
      let s:start_insert=terminus#private#wrap(s:start_insert)
      let s:end_insert=terminus#private#wrap(s:end_insert)
    endif

    let &t_SI=s:start_insert
    let &t_EI=s:end_insert
  endif
endif

let s:mouse=exists('g:TerminusMouse') ? g:TerminusMouse : 1
if s:mouse
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
endif

let s:focus=exists('g:TerminusFocusReporting') ? g:TerminusFocusReporting : 1
if s:focus
  if has('autocmd')
    augroup Terminus
      autocmd!
      autocmd FocusGained * checktime
    augroup END
  endif

  " Enable focus reporting on entering Vim.
  let &t_ti.="\e[?1004h"
  " Disable focus reporting on leaving Vim.
  let &t_te="\e[?1004l" . &t_te

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
endif

let s:paste=exists('g:TerminusBracketedPaste') ? g:TerminusBracketedPaste : 1
if s:paste
  " Make use of Xterm "bracketed paste mode". See:
  "  - http://www.xfree86.org/current/ctlseqs.html#Bracketed%20Paste%20Mode
  "  - http://stackoverflow.com/questions/5585129
  if s:screen || s:xterm
    " Enable bracketed paste mode on entering Vim.
    let &t_ti.="\e[?2004h"

    " Disable bracketed paste mode on leaving Vim.
    let &t_te="\e[?2004l" . &t_te

    set pastetoggle=<Esc>[201~
    inoremap <expr> <Esc>[200~ terminus#private#paste('')
    nnoremap <expr> <Esc>[200~ terminus#private#paste('i')
    vnoremap <expr> <Esc>[200~ terminus#private#paste('c')
    cnoremap <Esc>[200~ <nop>
    cnoremap <Esc>[201~ <nop>
  endif
endif

" Restore 'cpoptions' to its former value.
let &cpoptions=s:cpoptions
unlet s:cpoptions
