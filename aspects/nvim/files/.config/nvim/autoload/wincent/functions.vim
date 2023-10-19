let g:html_font=['Source Code Pro', 'Consolas', 'Monaco']

" Open a syntax-colored version of the current file
" suitable for copy-pasting into a presentation.
function! wincent#functions#keynote() abort
  setlocal nonumber
  setlocal norelativenumber
  TOhtml
  let l:tempfile=trim(system('mktemp')) . '.html'
  echomsg l:tempfile
  execute 'saveas! ' . l:tempfile
  execute '!open -b com.google.Chrome ' . l:tempfile
  quit
endfunction

" http://stackoverflow.com/a/39348498/2103996
function! wincent#functions#clearregisters() abort
  let l:regs=split('abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789/-"', '\zs')
  for l:reg in l:regs
    call setreg(l:reg, [])
  endfor
endfunction

" Like :echoerr, but without the stack trace.
function! wincent#functions#echoerr(msg) abort
  try
    echohl ErrorMsg
    echomsg a:msg
  finally
    echohl None
  endtry
endfunction
