"
" settings
"
let g:CommandTMatchWindowReverse   = 1
let g:CommandTMaxFiles             = 500000
let g:CommandTMaxHeight            = 30
let g:CommandTMaxCachedDirectories = 10
let g:CommandTScanDotDirectories   = 1

if &term =~ 'screen' || &term =~ 'xterm'
  let g:CommandTCancelMap = ['<ESC>', '<C-c>']
endif

"
" mappings
"

if has('jumplist')
  nnoremap <silent> <leader>j :CommandTJump<CR>
endif

nnoremap <leader>g :CommandTTag<CR>
