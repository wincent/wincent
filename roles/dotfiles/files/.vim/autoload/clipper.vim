function! clipper#clip() abort
  call system('nc localhost 8377', @0)
endfunction
