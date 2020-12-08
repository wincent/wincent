if !exists('g:ClipperLoaded')
  finish
endif

let g:ClipperAddress='~/.clipper.sock'
let g:ClipperPort=0

if filereadable('/etc/arch-release')
  if executable('socat')
    call clipper#set_invocation('socat - UNIX-CLIENT:' . expand(g:ClipperAddress))
  endif
endif
