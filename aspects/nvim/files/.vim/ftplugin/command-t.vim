  if has('statusline')
    execute 'setlocal statusline=\ \ ' . substitute(bufname('%'), ' ', '\\ ', 'g')
  endif
