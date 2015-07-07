" Copyright 2015-present Greg Hurrell. All rights reserved.
" Licensed under the terms of the BSD 2-clause license.

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

augroup Ferret
  autocmd!
  autocmd QuickFixCmdPost [^l]* nested cw
  autocmd QuickFixCmdPost l* nested lw
augroup END

command! -nargs=+ -complete=file Ack call ferret#ack(<q-args>)
nnoremap <leader>a :Ack<space>
command! -nargs=+ -complete=file Lack call ferret#lack(<q-args>)
nnoremap <leader>l :Lack<space>
command! -nargs=1 Acks call ferret#acks(<q-args>)

" Call :Ack with word currently under cursor (mnemonic: selection).
nnoremap <leader>s :Ack <C-r><C-w><CR>

" Populate the :args list with the filenames currently in the quickfix window.
command! -bar Qargs execute 'args' ferret#qargs()
