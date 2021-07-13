local wincent = require'wincent'

local setlocal = wincent.vim.setlocal

-- Don't let built-in plug-in override our setting here.
vim.b.did_ftplugin = 1

setlocal('colorcolumn', '')
setlocal('statusline', vim.g.WincentQuickfixStatusline)
