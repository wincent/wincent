scriptencoding utf-8

let s:box_drawings_light_vertical='│'

let g:indentLine_char=s:box_drawings_light_vertical

let g:indentLine_bufNameExclude=['NERD_tree.*']

if has('nvim') && !has('nvim-0.2.2')
  " Older versions of Neovim set the runtime path incorrectly, causing problems
  " with JSON.
  let g:indentLine_fileTypeExclude=['help', 'json', 'reason']
else
  let g:indentLine_fileTypeExclude=['help', 'reason']
endif
