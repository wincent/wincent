"
" settings
"
let g:CommandTMaxCachedDirectories = 10
let g:CommandTMaxFiles             = 1000000
let g:CommandTScanDotDirectories   = 1
let g:CommandTTraverseSCM          = 'pwd'
let g:CommandTFileScanner          = 'watchman'

let g:CommandTWildIgnore = &wildignore
let g:CommandTWildIgnore .= ',**/.git/*'
let g:CommandTWildIgnore .= ',**/.hg/*'
let g:CommandTWildIgnore .= ',**/bower_components/*'
let g:CommandTWildIgnore .= ',**/node_modules/*'
let g:CommandTWildIgnore .= ',**/tmp/*'

if &term =~# 'screen' || &term =~# 'xterm'
  let g:CommandTCancelMap = ['<ESC>', '<C-c>']
endif

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

function! s:GotoOrOpen(command_and_args)
  let l:command_and_args = split(a:command_and_args, '\v^\w+ \zs')
  let l:command = l:command_and_args[0]
  let l:file = l:command_and_args[1]

  " bufwinnr() doesn't see windows in other tabs, meaning we open them again
  " instead of switching to the other tab; but bufexists() sees hidden
  " buffers, and if we try to open one of those, we get an unwanted split.
  if bufwinnr(l:file) != -1 || (bufexists(l:file) && !s:BufHidden(l:file))
    execute 'sb ' . l:file
  else
    execute l:command . l:file
  endif
endfunction

command! -nargs=+ GotoOrOpen call s:GotoOrOpen(<q-args>)

let g:CommandTAcceptSelectionCommand = 'GotoOrOpen e'
let g:CommandTAcceptSelectionTabCommand = 'GotoOrOpen tabe'
let g:CommandTAcceptSelectionSplitCommand = 'GotoOrOpen sp'
let g:CommandTAcceptSelectionVSplitCommand = 'GotoOrOpen vs'
