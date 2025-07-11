local augroup = require('wincent.nvim.augroup')
local statusline = require('wincent.statusline')

statusline.set()

augroup('wincent.statusline', function(autocmd)
  autocmd('BufWinEnter,BufWritePost,FileWritePost,TextChanged,TextChangedI,WinEnter', '*', statusline.check_modified)
  autocmd('ColorScheme', '*', statusline.update_highlight)
  autocmd('User', 'FerretAsyncStart', statusline.async_start)
  autocmd('User', 'FerretAsyncFinish', statusline.async_finish)
end)
