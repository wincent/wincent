call wincent#functions#plaintext()

call wincent#autocomplete#deoplete_init()

setlocal synmaxcol=0

if bufname(bufnr('%')) == '__LanguageClient__'
  setlocal nonumber
  setlocal norelativenumber
endif
