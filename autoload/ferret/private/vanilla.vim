" Copyright 2015-present Greg Hurrell. All rights reserved.
" Licensed under the terms of the BSD 2-clause license.

function! ferret#private#vanilla#search(command, ack) abort
  let l:executable=ferret#private#executable()
  let l:output=system(l:executable . ' ' . a:command)
  call ferret#private#shared#finalize_search(l:output, a:ack)
endfunction
