if has('autocmd')
  augroup WincentAutocmds
    autocmd!

    " http://vim.wikia.com/wiki/Detect_window_creation_with_WinEnter
    autocmd VimEnter * autocmd WinEnter * let w:created=1
    autocmd VimEnter * let w:created=1

    " Disable paste mode on leaving insert mode.
    autocmd InsertLeave * set nopaste

    " Make current window more obvious by turning off/adjusting some features in non-current
    " windows.
    if exists('+colorcolumn')
      autocmd BufEnter,VimEnter,WinEnter * if autocmds#should_colorcolumn() | let &l:colorcolumn='+' . join(range(0, 254), ',+') | endif
      autocmd WinLeave * if autocmds#should_colorcolumn() | let &l:colorcolumn=join(range(1, 255), ',') | endif
    endif
    autocmd InsertLeave,VimEnter,WinEnter * if autocmds#should_cursorline() | setlocal cursorline | endif
    autocmd InsertEnter,WinLeave * if autocmds#should_cursorline() | setlocal nocursorline | endif
    if has('statusline')
      autocmd BufFilePost,VimEnter,WinEnter * call autocmds#focus_statusline()
      autocmd WinLeave * call autocmds#blur_statusline()
    endif

    if has('mksession')
      " Save/restore folds and cursor position.
      autocmd BufWritePost,BufLeave,WinLeave ?* if autocmds#should_mkview() | mkview | endif
      if has('folding')
        autocmd BufWinEnter ?* if autocmds#should_mkview() | silent! loadview | execute 'silent! ' . line('.') . 'foldopen!' | endif
      else
        autocmd BufWinEnter ?* if autocmds#should_mkview() | silent! loadview | endif
      endif
    elseif has('folding')
      " Like the autocmd described in `:h last-position-jump` but we add `:foldopen!`.
      autocmd BufWinEnter * if line("'\"") > 1 && line("'\"") <= line('$') | execute "normal! g`\"" | execute 'silent! ' . line("'\"") . 'foldopen!' | endif
    else
      autocmd BufWinEnter * if line("'\"") > 1 && line("'\"") <= line('$') | execute "normal! g`\"" | endif
    endif

    autocmd BufWritePost */spell/*.add silent! :mkspell! %
  augroup END
endif
