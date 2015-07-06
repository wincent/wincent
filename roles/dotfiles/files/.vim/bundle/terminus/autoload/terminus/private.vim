function! terminus#private#escape(string) abort
  " Double each <Esc>.
  return substitute(a:string, "\<Esc>", "\<Esc>\<Esc>", 'g')
endfunction

function! terminus#private#wrap(string) abort
  if strlen(a:string) == 0
    return ''
  end

  let l:tmux_begin="\<Esc>Ptmux;"
  let l:tmux_end="\<Esc>\\"

  return l:tmux_begin . terminus#private#escape(a:string) . l:tmux_end
endfunction

function! terminus#private#focus_lost() abort
  let l:cmdline=getcmdline()
  let l:cmdpos=getcmdpos()

  silent doautocmd FocusLost %

  call setcmdpos(l:cmdpos)
  return l:cmdline
endfunction

function! terminus#private#focus_gained() abort
  let l:cmdline=getcmdline()
  let l:cmdpos=getcmdpos()

  " Our checktime autocmd will produce:
  "   E523: Not allowed here:   checktime
  silent! doautocmd FocusGained %

  call setcmdpos(l:cmdpos)
  return l:cmdline
endfunction

function! terminus#private#paste(ret) abort
  set paste
  return a:ret
endfunction
