if &formatprg ==# '' && executable('par')
  " Can use `gw`/`gww` whenever `gq`/`gqq` does the wrong thing.
  let &formatprg='par rTbgqR B=.,\?_A_a_0 Q=_s\>'
endif

augroup WincentParAutocmds
  autocmd!
  autocmd FileType * call wincent#par#filetype(expand('<amatch>'))
augroup END
