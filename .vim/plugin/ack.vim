if executable('ag')       " The Silver Searcher: faster than ack
  let s:ackprg = 'ag --column --nocolor --nogroup'
elseif executable('ack')  " Ack: better than grep
  let s:ackprg = 'ack --column'
elseif executable('grep') " Grep: it's just grep
  let s:ackprg = &grepprg " default is: grep -n $* /dev/null
endif

if !empty(s:ackprg)
  let &grepprg=s:ackprg
  set grepformat=%f:%l:%c:%m
endif

autocmd QuickFixCmdPost [^l]* nested cw
autocmd QuickFixCmdPost l* nested lw

function! AckGrep(command)
  if empty(s:ackprg)
    return
  endif
  cexpr system(s:ackprg . ' ' . a:command)
  cw
endfunction

function! LackGrep(command)
  if empty(s:ackprg)
    return
  endif
  lexpr system(s:ackprg . ' ' . a:command)
  lw
endfunction

command! -nargs=+ -complete=file Ack call AckGrep(<q-args>)
nnoremap <leader>a :Ack<space>
command! -nargs=+ -complete=file Lack call LackGrep(<q-args>)
nnoremap <leader>l :Lack<space>

" call :Ack with word currently under cursor (mnemonic: selection)
nnoremap <leader>s :Ack <C-r><C-w><CR>

" populate the :args list with the filenames currently in the quickfix window
command! -nargs=0 -bar Qargs execute 'args' QuickfixFilenames()
function! QuickfixFilenames()
  let buffer_numbers = {}
  for quickfix_item in getqflist()
    let buffer_numbers[quickfix_item['bufnr']] = bufname(quickfix_item['bufnr'])
  endfor
  return join(map(values(buffer_numbers), 'fnameescape(v:val)'))
endfunction
