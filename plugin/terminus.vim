" Copyright 2015-present Greg Hurrell. All rights reserved.
" Licensed under the terms of the BSD 2-clause license.

" Provide users with means to prevent loading, as recommended in `:h
" write-plugin`.
if exists('g:TerminusLoaded') || &compatible || v:version < 700
  finish
endif
let g:TerminusLoaded=1

" Temporarily set 'cpoptions' to Vim default as per `:h use-cpo-save`.
let s:cpoptions=&cpoptions
set cpoptions&vim

set autoread " if not changed in Vim, automatically pick up changes after "git checkout" etc
if &ttimeoutlen == -1 && &timeoutlen > 10 || &ttimeoutlen > 10
  set ttimeoutlen=10 " speed up O etc in the Terminal
endif

let s:konsole=
      \ exists('$KONSOLE_DBUS_SESSION') ||
      \ exists('$KONSOLE_PROFILE_NAME')
let s:iterm=
      \ exists('$ITERM_PROFILE') ||
      \ exists('$ITERM_SESSION_ID') ||
      \ exists('g:TerminusAssumeITerm') ||
      \ filereadable(expand('~/.vim/.assume-iterm'))
let s:iterm2=
      \ s:iterm &&
      \ exists('$TERM_PROGRAM_VERSION') &&
      \ match($TERM_PROGRAM_VERSION, '\v^[2-9]\.') == 0
let s:screenish=&term =~# 'screen\|tmux'
let s:tmux=exists('$TMUX')
let s:xterm=&term =~# 'xterm'
let s:urxvt=&term =~# 'rxvt-unicode'

" Change shape of cursor in insert mode in iTerm 2.
let s:shape=get(g:, 'TerminusCursorShape', 1)
if s:shape
  if has('nvim')
    " Nothing to do, should work out of the box on recent versions.
  else
    let s:insert_shape=+get(g:, 'TerminusInsertCursorShape', 1)
    let s:replace_shape=+get(g:, 'TerminusReplaceCursorShape', 2)
    let s:normal_shape=+get(g:, 'TerminusNormalCursorShape', 0)
    if s:iterm2
      let s:start_insert="\<Esc>]1337;CursorShape=" . s:insert_shape . "\x7"
      let s:start_replace="\<Esc>]1337;CursorShape=" . s:replace_shape . "\x7"
      let s:end_insert="\<Esc>]1337;CursorShape=" . s:normal_shape . "\x7"
    elseif s:iterm || s:konsole
      let s:start_insert="\<Esc>]50;CursorShape=" . s:insert_shape . "\x7"
      let s:start_replace="\<Esc>]50;CursorShape=" . s:replace_shape . "\x7"
      let s:end_insert="\<Esc>]50;CursorShape=" . s:normal_shape . "\x7"
    else
      let s:cursor_shape_to_vte_shape={1: 6, 2: 4, 0: 2}
      let s:insert_shape=s:cursor_shape_to_vte_shape[s:insert_shape]
      let s:replace_shape=s:cursor_shape_to_vte_shape[s:replace_shape]
      let s:normal_shape=s:cursor_shape_to_vte_shape[s:normal_shape]
      let s:start_insert="\<Esc>[" . s:insert_shape . ' q'
      let s:start_replace="\<Esc>[" . s:replace_shape . ' q'
      let s:end_insert="\<Esc>[" . s:normal_shape . ' q'
    endif

    if s:tmux
      let s:start_insert=terminus#private#wrap(s:start_insert)
      let s:start_replace=terminus#private#wrap(s:start_replace)
      let s:end_insert=terminus#private#wrap(s:end_insert)
    endif

    let &t_SI=s:start_insert
    if v:version > 704 || v:version == 704 && has('patch687')
      let &t_SR=s:start_replace
    end
    let &t_EI=s:end_insert
  endif
endif

let s:mouse=get(g:, 'TerminusMouse', 1)
if s:mouse
  if has('mouse')
    set mouse=a
    if s:iterm2 || s:screenish || s:xterm
      if !has('nvim')
        if has('mouse_sgr')
          set ttymouse=sgr
        else
          set ttymouse=xterm2
        endif
      endif
    endif
  endif
endif

let s:focus=get(g:, 'TerminusFocusReporting', 1)
if s:focus
  if has('autocmd')
    augroup Terminus
      autocmd!
      " Use silent! to avoid potential E11 if the command-line window is open.
      autocmd FocusGained * silent! checktime

      if s:tmux
        " We may not get FocusGained/FocusLost events, or we may get them late,
        " when they are due to pane creation/destruction.
        if has('timers')
          autocmd VimResized * call terminus#private#schedulecheck()
        else
          autocmd VimResized * call terminus#private#checkfocus()
        endif
      endif
    augroup END
  endif

  if !has('nvim')
    " Enable focus reporting on entering Vim.
    let &t_ti.="\e[?1004h"
    " Disable focus reporting on leaving Vim.
    let &t_te="\e[?1004l" . &t_te

    execute "set <f20>=\<Esc>[O"
    execute "set <f21>=\<Esc>[I"
    cnoremap <silent> <f20> <c-\>eterminus#private#focus_lost()<cr>
    cnoremap <silent> <f21> <c-\>eterminus#private#focus_gained()<cr>

    if has('terminal')
      " Trigger FocusLost/Gained autocommands while in terminal (gvim like).
      " Indirectly fixes scrambled ??? characters in Vim terminals.
      tmap <expr> <f20> terminus#private#term_focus_lost()
      tmap <expr> <f21> terminus#private#term_focus_gained()
    endif

    if v:version > 703 || v:version == 703 && has('patch438')
      " <nomodeline> was added in 7.3.438 (see `:h version7.txt`).
      inoremap <silent> <f20> <c-\><c-o>:silent doautocmd <nomodeline> FocusLost %<cr>
      inoremap <silent> <f21> <c-\><c-o>:silent doautocmd <nomodeline> FocusGained %<cr>
      nnoremap <silent> <f20> :silent doautocmd <nomodeline> FocusLost %<cr>
      nnoremap <silent> <f21> :silent doautocmd <nomodeline> FocusGained %<cr>
      onoremap <silent> <f20> <Esc>:silent doautocmd <nomodeline> FocusLost %<cr>
      onoremap <silent> <f21> <Esc>:silent doautocmd <nomodeline> FocusGained %<cr>
      vnoremap <silent> <f20> <Esc>:silent doautocmd <nomodeline> FocusLost %<cr>gv
      vnoremap <silent> <f21> <Esc>:silent doautocmd <nomodeline> FocusGained %<cr>gv
    else
      inoremap <silent> <f20> <c-\><c-o>:silent doautocmd FocusLost %<cr>
      inoremap <silent> <f21> <c-\><c-o>:silent doautocmd FocusGained %<cr>
      nnoremap <silent> <f20> :silent doautocmd FocusLost %<cr>
      nnoremap <silent> <f21> :silent doautocmd FocusGained %<cr>
      onoremap <silent> <f20> <Esc>:silent doautocmd FocusLost %<cr>
      onoremap <silent> <f21> <Esc>:silent doautocmd FocusGained %<cr>
      vnoremap <silent> <f20> <Esc>:silent doautocmd FocusLost %<cr>gv
      vnoremap <silent> <f21> <Esc>:silent doautocmd FocusGained %<cr>gv
    endif
  endif
endif

let s:paste=get(g:, 'TerminusBracketedPaste', 1)
if s:paste && !has('nvim')
  " Make use of Xterm "bracketed paste mode". See:
  "  - http://www.xfree86.org/current/ctlseqs.html#Bracketed%20Paste%20Mode
  "  - http://stackoverflow.com/questions/5585129
  if s:screenish || s:xterm || s:urxvt
    " Enable bracketed paste mode on entering Vim.
    let &t_ti.="\e[?2004h"

    " Disable bracketed paste mode on leaving Vim.
    let &t_te="\e[?2004l" . &t_te

    set pastetoggle=<f23>
    execute "set <f22>=\<Esc>[200~"
    execute "set <f23>=\<Esc>[201~"
    inoremap <expr> <f22> terminus#private#paste('')
    nnoremap <expr> <f22> terminus#private#paste('i')
    vnoremap <expr> <f22> terminus#private#paste('c')
    cnoremap <f22> <nop>
    cnoremap <f23> <nop>
  endif
endif

" Restore 'cpoptions' to its former value.
let &cpoptions=s:cpoptions
unlet s:cpoptions
