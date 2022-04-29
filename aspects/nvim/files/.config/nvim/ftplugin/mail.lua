-- See also: after/ftplugin/mail.lua.

local setlocal = wincent.vim.setlocal

setlocal('list', false)
setlocal('synmaxcol', 0)

vim.keymap.set('n', 'j', 'gj', {buffer = true})
vim.keymap.set('n', 'k', 'gk', {buffer = true})

wincent.vim.spell()
