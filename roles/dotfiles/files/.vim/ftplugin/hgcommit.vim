if has('syntax')
  setlocal spell
endif

call functions#plaintext()

" Can't just call colorcolumn=72 here because it's really only the first line
" whose length we care about, and our focus tricks elsewhere would overwrite it
" for us anyway.
call matchaddpos('ErrorMsg', [[1, 72, 1000]])
