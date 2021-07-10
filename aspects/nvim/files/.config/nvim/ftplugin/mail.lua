-- See also: after/ftplugin/mail.lua.

local wincent = require'wincent'

local nnoremap = wincent.vim.nnoremap

vim.opt_local.list = false
vim.opt_local.synmaxcol = 0

nnoremap('j', 'gj', {buffer = true})
nnoremap('k', 'gk', {buffer = true})

wincent.vim.spell()
