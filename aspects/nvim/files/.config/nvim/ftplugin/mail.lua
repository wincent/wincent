-- See also: after/ftplugin/mail.lua.

vim.opt_local.list = false
vim.opt_local.synmaxcol = 0

vim.keymap.set('n', 'j', 'gj', { buffer = true })
vim.keymap.set('n', 'k', 'gk', { buffer = true })

wincent.vim.spell()
