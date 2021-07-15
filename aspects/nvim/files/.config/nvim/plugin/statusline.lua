local augroup = wincent.vim.augroup
local autocmd = wincent.vim.autocmd

wincent.statusline.set()

augroup('WincentStatusline', function()
  autocmd(
    'BufWinEnter,BufWritePost,FileWritePost,TextChanged,TextChangedI,WinEnter',
    '*',
    wincent.statusline.check_modified
  )
  autocmd('ColorScheme', '*', wincent.statusline.update_highlight)
  autocmd('User', 'FerretAsyncStart', wincent.statusline.async_start)
  autocmd('User', 'FerretAsyncFinish', wincent.statusline.async_finish)
end)
