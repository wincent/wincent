" Guard, in case Ferret is ever disabled by commenting out the
" corresponding packadd call.
if exists('g:FerretLoaded')
  let g:FerretExecutableArguments={
        \   'rg': ferret#get_default_arguments('rg') . ' --hidden --glob !.git'
        \ }
endif
