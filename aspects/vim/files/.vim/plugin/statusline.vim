scriptencoding utf-8

if has('nvim')
  lua require'wincent.statusline'.set()

  augroup WincentStatusline
    autocmd!
    autocmd ColorScheme * call wincent#statusline#update_highlight()
    autocmd User FerretAsyncStart call wincent#statusline#async_start()
    autocmd User FerretAsyncFinish call wincent#statusline#async_finish()
    if exists('##TextChangedI')
      autocmd BufWinEnter,BufWritePost,FileWritePost,TextChanged,TextChangedI,WinEnter * call wincent#statusline#check_modified()
    else
      autocmd BufWinEnter,BufWritePost,FileWritePost,WinEnter * call wincent#statusline#check_modified()
    endif
  augroup END
endif
