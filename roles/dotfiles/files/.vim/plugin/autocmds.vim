augroup wincent
  autocmd!

  " http://vim.wikia.com/wiki/Detect_window_creation_with_WinEnter
  autocmd VimEnter * autocmd WinEnter * let w:created=1
  autocmd VimEnter * let w:created=1

  if has('folding')
    " like the autocmd described in `:h last-position-jump` but we add `:foldopen!`
    autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | exe "silent! foldopen!" | endif
  else
    autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
  endif

  " except for Git commit messages, where this gets old really fast
  autocmd BufReadPost COMMIT_EDITMSG exec "normal! gg"

  " disable paste mode on leaving insert mode
  autocmd InsertLeave * set nopaste
augroup END
