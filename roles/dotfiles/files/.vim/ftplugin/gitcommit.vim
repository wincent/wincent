if has('folding')
  setlocal nofoldenable
endif

if has('syntax')
  setlocal spell
endif

" This slows down initialization but it's too damn useful not to have it right
" from the start.
call wincent#autocomplete#deoplete_init()
