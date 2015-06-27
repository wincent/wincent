augroup WincentAutocmds
  autocmd!

  " http://vim.wikia.com/wiki/Detect_window_creation_with_WinEnter
  autocmd VimEnter * autocmd WinEnter * let w:created=1
  autocmd VimEnter * let w:created=1

  if has('folding')
    " Like the autocmd described in `:h last-position-jump` but we add `:foldopen!`.
    autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line('$') | execute "normal! g`\"" | execute 'silent! foldopen!' | endif
  else
    autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line('$') | execute "normal! g`\"" | endif
  endif

  " Except for Git commit messages, where this gets old really fast.
  autocmd BufReadPost COMMIT_EDITMSG execute 'normal! gg'

  " Disable paste mode on leaving insert mode.
  autocmd InsertLeave * set nopaste

  " Make current window more obvious by turning off/adjusting some features in non-current
  " windows.
  if exists('+colorcolumn')
    autocmd VimEnter,WinEnter * let &l:colorcolumn='+' . join(range(0, 254), ',+')
    autocmd WinLeave * let &l:colorcolumn=join(range(1, 255), ',')
  endif
  if exists('+cursorcolumn')
    if has('gui_running')
      autocmd InsertLeave,VimEnter,WinEnter * setlocal cursorcolumn
      autocmd InsertEnter,WinLeave * setlocal nocursorcolumn
    endif
  endif
  autocmd InsertEnter * setlocal nocursorline
  autocmd InsertLeave * setlocal cursorline
  autocmd VimEnter,WinEnter * setlocal cursorline | call autocmds#blur_statusline()
  autocmd WinLeave * setlocal nocursorline | call autocmds#focus_statusline()

  if has('mksession')
    " Save/restore folds and cursor position.
    autocmd BufWritePost,BufLeave,WinLeave ?* if autocmds#should_mkview() | mkview | endif
    autocmd BufWinEnter ?* if autocmds#should_mkview() | silent loadview | endif
  endif
augroup END
