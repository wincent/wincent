" Dynamically returns "/" or "/\v" depending on the location of the just-typed
" "/" within the command-line. Only "/" that looks to be at the start of a
" command gets replaced.
function! mappings#very_magic_slash()
  if getcmdtype() != ':'
    return '/'
  endif

  let l:pos = getcmdpos()
  let l:cmd = getcmdline()

  if l:pos == 2 && l:cmd ==# 'g'
    return '/\v'
  elseif l:pos == 2 && l:cmd ==# 'v'
    return '/\v'
  elseif l:pos == 3 && l:cmd ==# '%s'
    return '/\v'
  endif

  return '/'
endfunction
