" For reference, see hgcommit.vim in this same directory.
if has('syntax')
  setlocal spell
endif

call wincent#functions#plaintext()
call matchaddpos('ErrorMsg', [[1, 72, 1000]])
