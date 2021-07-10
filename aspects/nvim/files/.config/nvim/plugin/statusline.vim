lua require'wincent.statusline'.set()

augroup WincentStatusline
  autocmd!
  autocmd ColorScheme * lua require'wincent.statusline'.update_highlight()
  autocmd User FerretAsyncStart lua require'wincent.statusline'.async_start()
  autocmd User FerretAsyncFinish lua require'wincent.statusline'.async_finish()
  autocmd BufWinEnter,BufWritePost,FileWritePost,TextChanged,TextChangedI,WinEnter * lua require'wincent.statusline'.check_modified()
augroup END
