" Copyright 2015-present Greg Hurrell. All rights reserved.
" Licensed under the terms of the BSD 2-clause license.

let s:nomodeline=v:version > 703 || v:version == 703 && has('patch438')

function! s:escape(string) abort
  " Double each <Esc>.
  return substitute(a:string, "\<Esc>", "\<Esc>\<Esc>", 'g')
endfunction

function! terminus#private#wrap(string) abort
  if strlen(a:string) == 0
    return ''
  end

  let l:tmux_begin="\<Esc>Ptmux;"
  let l:tmux_end="\<Esc>\\"

  return l:tmux_begin . s:escape(a:string) . l:tmux_end
endfunction

function! terminus#private#focus_lost() abort
  let l:cmdline=getcmdline()
  let l:cmdpos=getcmdpos()

  if s:nomodeline
    silent doautocmd <nomodeline> FocusLost %
  else
    silent doautocmd FocusLost %
  endif

  call setcmdpos(l:cmdpos)
  return l:cmdline
endfunction

function! terminus#private#focus_gained() abort
  let l:cmdline=getcmdline()
  let l:cmdpos=getcmdpos()

  " Use `:silent!` here because our checktime autocmd will produce:
  "   E523: Not allowed here:   checktime
  if s:nomodeline
    silent! doautocmd <nomodeline> FocusGained %
  else
    silent! doautocmd FocusGained %
  endif

  call setcmdpos(l:cmdpos)
  return l:cmdline
endfunction

function! terminus#private#term_focus_lost() abort
  if s:nomodeline
    silent doautocmd <nomodeline> FocusLost %
  else
    silent doautocmd FocusLost %
  endif
  return '' " It's executed as a tmap <expr>, so return nothing to type
endfunction

function! terminus#private#term_focus_gained() abort
  if s:nomodeline
    silent! doautocmd <nomodeline> FocusGained %
  else
    silent! doautocmd FocusGained %
  endif
  return '' " It's executed as a tmap <expr>, so return nothing to type
endfunction

function! terminus#private#paste(ret) abort
  set paste
  return a:ret
endfunction

function! terminus#private#checkfocus() abort
  if exists('$TMUX') && exists('$TMUX_PANE')
    let l:pane_id=$TMUX_PANE
    let l:panes=split(system('tmux list-panes -F "#{pane_active} #{pane_id}"'), '\n')
    let l:active=filter(l:panes, 'match(v:val, "^1 ") == 0')
    if len(l:active) == 1
      let l:match=matchstr(l:active[0], '\v1 \zs\%\d+$')
      if l:match != ''
        let l:autocmd=(l:match == l:pane_id ? 'FocusGained' : 'FocusLost')
        if s:nomodeline
          execute 'silent! doautocmd <nomodeline> ' . l:autocmd . ' %'
        else
          execute 'silent! doautocmd ' . l:autocmd . ' %'
        end
      endif
    endif
  endif
endfunction

function! terminus#private#handletimer(timer) abort
  if exists('g:TerminusPendingFocusTimer')
    unlet g:TerminusPendingFocusTimer
  endif
  call terminus#private#checkfocus()
endfunction

function! terminus#private#schedulecheck() abort
  if exists('g:TerminusPendingFocusTimer')
    call timer_stop(g:TerminusPendingFocusTimer)
  endif
  let g:TerminusPendingFocusTimer=timer_start(
        \   50,
        \   'terminus#private#handletimer'
        \ )
endfunction
