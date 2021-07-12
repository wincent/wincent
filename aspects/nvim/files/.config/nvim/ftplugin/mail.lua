-- See also: after/ftplugin/mail.lua.

local wincent = require'wincent'

local nnoremap = wincent.vim.nnoremap
local setlocal = wincent.vim.setlocal

setlocal('list', false)
setlocal('synmaxcol', 0)

nnoremap('j', 'gj', {buffer = true})
nnoremap('k', 'gk', {buffer = true})

wincent.vim.spell()
