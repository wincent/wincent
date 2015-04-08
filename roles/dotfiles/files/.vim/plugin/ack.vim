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

augroup WincentAck
  autocmd!
  autocmd QuickFixCmdPost [^l]* nested cw
  autocmd QuickFixCmdPost l* nested lw
augroup END

command! -nargs=+ -complete=file Ack call ack#ack(<q-args>)
nnoremap <leader>a :Ack<space>
command! -nargs=+ -complete=file Lack call ack#lack(<q-args>)
nnoremap <leader>l :Lack<space>
command! -nargs=1 Acks call ack#acks(<q-args>)

" Call :Ack with word currently under cursor (mnemonic: selection).
nnoremap <leader>s :Ack <C-r><C-w><CR>

" Populate the :args list with the filenames currently in the quickfix window.
command! -bar Qargs execute 'args' ack#qargs()
