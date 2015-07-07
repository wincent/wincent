" Copyright 2015-present Greg Hurrell. All rights reserved.
" Licensed under the terms of the BSD 2-clause license.

function! clipper#clip() abort
  if executable('nc') == 1
    " Co-erce port to number.
    let l:port = +(exists('g:ClipperPort') ? g:ClipperPort : 8377)
    call system('nc localhost ' . l:port, @0)
  else
    echoerr 'Clipper: nc executable does not exist'
  endif
endfunction
