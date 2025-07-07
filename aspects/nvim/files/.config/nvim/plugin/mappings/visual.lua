--
-- Visual mode mappings.
--

local wrap_mapping = require('wincent.plugins.ibl.wrap_mapping')

-- Move between windows.
vim.keymap.set('x', '<C-h>', '<C-w>h')
vim.keymap.set('x', '<C-j>', '<C-w>j')
vim.keymap.set('x', '<C-k>', '<C-w>k')
vim.keymap.set('x', '<C-l>', '<C-w>l')

-- Move VISUAL LINE selection within buffer.
vim.api.nvim_create_user_command('MoveDown', require('wincent.mappings.visual').move_down, { range = true })
vim.api.nvim_create_user_command('MoveUp', require('wincent.mappings.visual').move_up, { range = true })

vim.keymap.set('x', 'K', ':MoveUp<CR>', { silent = true })
vim.keymap.set('x', 'J', ':MoveDown<CR>', { silent = true })

-- For compatibility with indent-blankline.nvim:
vim.keymap.set('x', '<', wrap_mapping('<'), { silent = true })
vim.keymap.set('x', '>', wrap_mapping('>'), { silent = true })
