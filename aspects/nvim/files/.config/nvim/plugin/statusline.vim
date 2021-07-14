lua wincent.statusline.set()

augroup WincentStatusline
  autocmd!
  autocmd ColorScheme * lua wincent.statusline.update_highlight()
  autocmd User FerretAsyncStart lua wincent.statusline.async_start()
  autocmd User FerretAsyncFinish lua wincent.statusline.async_finish()
  autocmd BufWinEnter,BufWritePost,FileWritePost,TextChanged,TextChangedI,WinEnter * lua wincent.statusline.check_modified()
augroup END
