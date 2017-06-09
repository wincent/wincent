let g:indentLine_bufNameExclude=['NERD_tree.*']

if has('nvim')
  let g:indentLine_fileTypeExclude=['help', 'json']
else
  let g:indentLine_fileTypeExclude=['help']
endif
