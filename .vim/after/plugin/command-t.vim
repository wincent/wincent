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

"
" buffer/split/tab re-use magic
"

function! s:GotoOrOpen(command, ...)
  for file in a:000
    if bufwinnr(file) != -1
      exec "sb " . file
    else
      exec a:command . " " . file
    endif
  endfor
endfunction

command! -nargs=+ GotoOrOpen call s:GotoOrOpen(<f-args>)

let g:CommandTAcceptSelectionCommand = 'GotoOrOpen e'
let g:CommandTAcceptSelectionTabCommand = 'GotoOrOpen tabe'
let g:CommandTAcceptSelectionSplitCommand = 'GotoOrOpen sp'
let g:CommandTAcceptSelectionVSplitCommand = 'GotoOrOpen vs'
