let s:raquo='»'
let s:middot='·'

" Override default `foldtext()`, which produces something like:
"
"   +---  2 lines: source $HOME/.vim/pack/bundle/opt/vim-pathogen/autoload/pathogen.vim--------------------------------
"
" Instead returning:
"
"   »····2 lines: source $HOME/.vim/pack/bundle/opt/vim-pathogen/autoload/pathogen.vim·································
function! wincent#settings#foldtext() abort
  let l:lines=(v:foldend - v:foldstart + 1) . ' lines'
  let l:first=substitute(getline(v:foldstart), '\v *', '', '')
  let l:dashes=substitute(v:folddashes, '-', s:middot, 'g')
  return s:raquo . l:dashes . s:middot . s:middot . l:lines . ': ' . l:first
endfunction
