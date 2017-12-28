let g:indentLine_bufNameExclude=['NERD_tree.*']

if has('nvim') && !has('nvim-0.2.2')
  " Older versions of Neovim set the runtime path incorrectly, causing problems
  " with JSON.
  let g:indentLine_fileTypeExclude=['help', 'json']
else
  let g:indentLine_fileTypeExclude=['help']
endif
