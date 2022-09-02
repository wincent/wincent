vim.keymap.set('n', '{', ':keeppatterns ?^\\d<CR>', { buffer = true, silent = true })
vim.keymap.set('n', '}', ':keeppatterns /^\\d<CR>', { buffer = true, silent = true })
