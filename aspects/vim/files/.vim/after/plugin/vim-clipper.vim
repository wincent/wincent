if !exists('g:ClipperLoaded')
  finish
endif

let g:ClipperAddress='~/.clipper.sock'
let g:ClipperPort=0

if filereadable('/etc/arch-release') && executable('socat')
  call clipper#set_invocation('socat - UNIX-CLIENT:' . expand(g:ClipperAddress))
elseif filereadable('/etc/debian_version') && executable('socat')
  call clipper#set_invocation('socat - UNIX-CLIENT:' . expand(g:ClipperAddress))
else
  call clipper#set_invocation('')
endif
