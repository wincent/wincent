function commands#preview(...)
  if a:0 == 0
    execute "!open -a 'Marked 2.app' ". expand('%')
    return
  endif
  for l:file in a:000
    execute "!open -a 'Marked 2.app' " . l:file
  endfor
endfunction
