" Switch to plaintext mode with: call functions#plaintext()
function! functions#plaintext() abort
  setlocal linebreak
  setlocal nolist
  setlocal spell
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
function! functions#keynote() abort
  if has('gui')
    setlocal nonumber
    setlocal norelativenumber
    TOhtml
    let l:tempfile=system('mktemp')
    execute 'saveas! ' . l:tempfile
    execute '!open -b com.google.Chrome ' . l:tempfile
    quit
  else
    echoerr 'functions#keynote() should be run from within a GUI instance of Vim'
  endif
endfunction

" Sort a .gitmodules file.
"
" See also: https://wincent.com/wiki/Sorting_.gitmodules_entries_with_Vim
function! functions#sortgitmodules(...) abort
  if &ft ==# 'gitconfig' || a:0
    silent %s/\v\n\t/@@@/e
    %sort
    silent %s/\v\@\@\@/\r\t/ge
  else
    echomsg 'Not a "gitconfig" file: use `functions#sortgitmodules(1)` to force'
  endif
endfunction
