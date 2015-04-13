"
" settings
"
let g:CommandTMatchWindowReverse   = 1
let g:CommandTMaxCachedDirectories = 10
let g:CommandTMaxFiles             = 500000
let g:CommandTMaxHeight            = 30
let g:CommandTScanDotDirectories   = 1

let g:CommandTWildIgnore = &wildignore
let g:CommandTWildIgnore .= ',**/.git/*'
let g:CommandTWildIgnore .= ',**/.hg/*'
let g:CommandTWildIgnore .= ',**/bower_components/*'
let g:CommandTWildIgnore .= ',**/node_modules/*'
let g:CommandTWildIgnore .= ',**/tmp/*'

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

function! s:BufHidden(buffer)
  let bufno = bufnr(a:buffer)
  let listed_buffers = ''

  redir => listed_buffers
  silent ls
  redir END

  for line in split(listed_buffers, "\n")
    let components = split(line)
    if components[0] == bufno
      return match(components[1], 'h') != -1
    endif
  endfor
  return 0
endfunction

function! s:GotoOrOpen(command, ...)
  for file in a:000
    " bufwinnr() doesn't see windows in other tabs, meaning we open them again
    " instead of switching to the other tab; but bufexists() sees hidden
    " buffers, and if we try to open one of those, we get an unwanted split.
    if bufwinnr(file) != -1 || (bufexists(file) && !s:BufHidden(file))
      execute 'sb ' . file
    else
      execute a:command . ' ' . file
    endif
  endfor
endfunction

command! -nargs=+ GotoOrOpen call s:GotoOrOpen(<f-args>)

let g:CommandTAcceptSelectionCommand = 'GotoOrOpen e'
let g:CommandTAcceptSelectionTabCommand = 'GotoOrOpen tabe'
let g:CommandTAcceptSelectionSplitCommand = 'GotoOrOpen sp'
let g:CommandTAcceptSelectionVSplitCommand = 'GotoOrOpen vs'
