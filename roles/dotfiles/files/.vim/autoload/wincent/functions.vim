" Switch to plaintext mode with: call wincent#functions#plaintext()
function! wincent#functions#plaintext() abort
  if has('conceal')
    let b:indentLine_ConcealOptionSet=1 " Don't let indentLine overwrite us.
    setlocal concealcursor=nc
  endif
  setlocal nolist
  if has('syntax')
    setlocal spell
    setlocal spelllang=en,es
  endif
  setlocal textwidth=0
  setlocal wrap
  setlocal wrapmargin=0

  nnoremap <buffer> j gj
  nnoremap <buffer> k gk

  " Ideally would keep 'list' set, and restrict 'listchars' to just show
  " whitespace errors, but 'listchars' is global and I don't want to go through
  " the hassle of saving and restoring.
  if has('autocmd')
    autocmd BufWinEnter <buffer> match Error /\s\+$/
    autocmd InsertEnter <buffer> match Error /\s\+\%#\@<!$/
    autocmd InsertLeave <buffer> match Error /\s\+$/
    autocmd BufWinLeave <buffer> call clearmatches()
  endif
endfunction

" Open a syntax-colored version of the current file
" suitable for copy-pasting into a presentation.
function! wincent#functions#keynote() abort
  if has('gui')
    setlocal nonumber
    setlocal norelativenumber
    TOhtml
    let l:tempfile=system('mktemp')
    execute 'saveas! ' . l:tempfile
    execute '!open -b com.google.Chrome ' . l:tempfile
    quit
  else
    echoerr 'wincent#functions#keynote() should be run from within a GUI instance of Vim'
  endif
endfunction

function! wincent#functions#substitute(pattern, replacement, flags) abort
  let l:number=1
  for l:line in getline(1, '$')
    call setline(l:number, substitute(l:line, a:pattern, a:replacement, a:flags))
    let l:number=l:number + 1
  endfor
endfunction

" Sort a .gitmodules file.
"
" See also: https://wincent.com/wiki/Sorting_.gitmodules_entries_with_Vim
function! wincent#functions#sortgitmodules(...) abort
  if &ft ==# 'gitconfig' || a:0
    silent %s/\v\n\t/@@@/e
    %sort
    silent %s/\v\@\@\@/\r\t/ge
  else
    echomsg 'Not a "gitconfig" file: use `wincent#functions#sortgitmodules(1)` to force'
  endif
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
