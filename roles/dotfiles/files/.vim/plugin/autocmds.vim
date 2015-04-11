augroup WincentAutocmds
  autocmd!

  " http://vim.wikia.com/wiki/Detect_window_creation_with_WinEnter
  autocmd VimEnter * autocmd WinEnter * let w:created=1
  autocmd VimEnter * let w:created=1

  if has('folding')
    " like the autocmd described in `:h last-position-jump` but we add `:foldopen!`
    autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line('$') | execute "normal! g`\"" | execute 'silent! foldopen!' | endif
  else
    autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line('$') | execute "normal! g`\"" | endif
  endif

  " except for Git commit messages, where this gets old really fast
  autocmd BufReadPost COMMIT_EDITMSG execute 'normal! gg'

  " disable paste mode on leaving insert mode
  autocmd InsertLeave * set nopaste

  " Make current window more obvious by turning off some features in non-current
  " windows.
  if exists('+colorcolumn')
    autocmd VimEnter,WinEnter * setlocal colorcolumn=+0
    autocmd WinLeave * setlocal colorcolumn=0
  endif
  autocmd VimEnter,WinEnter * setlocal cursorline | setlocal list | setlocal statusline=
  autocmd WinLeave * setlocal nocursorline | setlocal nolist | setlocal statusline=%n:%<%f
augroup END
