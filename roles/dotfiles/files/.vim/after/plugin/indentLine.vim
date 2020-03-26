scriptencoding utf-8

" BROKEN BAR Unicode: U+00A6, UTF-8: C2 A6
let s:broken_bar='¦'

let g:indentLine_char=s:broken_bar

let g:indentLine_bufNameExclude=['NERD_tree.*']

let g:indentLine_fileTypeExclude=['help', 'markdown', 'reason']
