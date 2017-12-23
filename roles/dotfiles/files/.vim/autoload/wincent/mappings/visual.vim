function! s:Visual()
  return visualmode() == 'V'
endfunction

function! wincent#mappings#visual#move_up() abort range
  let l:at_top=a:firstline == 1
  if s:Visual() && !l:at_top
    '<,'>move '<-2
    call feedkeys('gv=', 'n')
  endif
  call feedkeys('gv', 'n')
endfunction

function! wincent#mappings#visual#move_down() abort range
  let l:at_bottom=a:lastline == line('$')
  if s:Visual() && !l:at_bottom
    '<,'>move '>+1
    call feedkeys('gv=', 'n')
  endif
  call feedkeys('gv', 'n')
endfunction
