function! wincent#mappings#leader#matchparen() abort
  " Preserve current window because {Do,No}MatchParen cycle with :windo.
  let l:currwin=winnr()
  if exists('g:loaded_matchparen')
    NoMatchParen
  else
    DoMatchParen
  endif
  execute l:currwin . 'wincmd w'
endfunction
