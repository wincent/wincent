if has('syntax')
  setlocal spell
endif

call wincent#functions#plaintext()

" Can't just use 'colorcolumn' here because it's really only the first line
" whose length we care about, and our focus tricks elsewhere would overwrite
" it for us anyway.
call matchaddpos('ErrorMsg', [[1, 72, 1000]])

" This slows down initialization but it's too damn useful not to have it right
" from the start.
call wincent#autocomplete#deoplete_init()
