function! terminus#private#escape(string) abort
  " double each <Esc>
  return substitute(a:string, "\<Esc>", "\<Esc>\<Esc>", 'g')
endfunction

function! terminus#private#wrap(string) abort
  if strlen(a:string) == 0
    return ''
  end

  let l:tmux_begin  = "\<Esc>Ptmux;"
  let l:tmux_end    = "\<Esc>\\"

  return l:tmux_begin . terminus#private#escape(a:string) . l:tmux_end
endfunction

function! terminus#private#focus_lost() abort
  let cmdline = getcmdline()
  let cmdpos  = getcmdpos()

  silent doautocmd FocusLost %

  call setcmdpos(cmdpos)
  return cmdline
endfunction

function! terminus#private#focus_gained() abort
  let cmdline = getcmdline()
  let cmdpos  = getcmdpos()

  " our checktime autocmd will produce:
  " E523: Not allowed here:   checktime
  silent! doautocmd FocusGained %

  call setcmdpos(cmdpos)
  return cmdline
endfunction

function! terminus#private#paste(ret) abort
  set paste
  return a:ret
endfunction
