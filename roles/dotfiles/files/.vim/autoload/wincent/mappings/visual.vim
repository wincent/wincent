function! s:CanMove()
  return visualmode() == 'V'
endfunction

function! s:AtTop()
  if has('nvim')
    let l:start=nvim_buf_get_mark(nvim_get_current_buf(), '<')
    let l:line=l:start[0]
    return l:line == 1
  else
    return line('v') == 1
  endif
endfunction

function! s:AtBottom()
  if has('nvim')
    let l:end=nvim_buf_get_mark(nvim_get_current_buf(), '>')
    let l:line=l:end[0]
    return l:line == line('$')
  else
    return line('.') == line('$')
  endif
endfunction

function! wincent#mappings#visual#move_up() abort range
  let l:at_top=a:firstline == 1
  if s:CanMove() && !l:at_top
    '<,'>move '<-2
    call feedkeys('gv=', 'n')
  endif
  call feedkeys('gv', 'n')
endfunction

function! wincent#mappings#visual#move_down() abort range
  let l:at_bottom=a:lastline == line('$')
  if s:CanMove() && !l:at_bottom
    '<,'>move '>+1
    call feedkeys('gv=', 'n')
  endif
  call feedkeys('gv', 'n')
endfunction
