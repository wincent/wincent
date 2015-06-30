" Dynamically returns "/" or "/\v" depending on the location of the just-typed
" "/" within the command-line. Only "/" that looks to be at the start of a
" command gets replaced.
function! mappings#very_magic_slash()
  if getcmdtype() != ':'
    return '/'
  endif

  " For simplicity, only consider "/" typed at the end of the command-line.
  let l:pos = getcmdpos()
  let l:cmd = getcmdline()
  if len(l:cmd) + 1 != l:pos
    return '/'
  endif

  if l:cmd ==# 'g'
    return '/\v'
  elseif l:cmd ==# 'v'
    return '/\v'
  elseif l:cmd ==# '%s'
    return '/\v'
  endif

  return '/'
endfunction
