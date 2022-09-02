--
-- Visual mode mappings.
--

local indent_wrap_mapping = wincent.plugins.indent_blankline.wrap_mapping
local command = wincent.vim.command

-- Move between windows.
vim.keymap.set('x', '<C-h>', '<C-w>h')
vim.keymap.set('x', '<C-j>', '<C-w>j')
vim.keymap.set('x', '<C-k>', '<C-w>k')
vim.keymap.set('x', '<C-l>', '<C-w>l')

-- Move VISUAL LINE selection within buffer.
command('MoveDown', 'call v:lua.wincent.mappings.visual.move_down(<line2>)', { range = true })
command('MoveUp', 'call v:lua.wincent.mappings.visual.move_up(<line1>)', { range = true })

vim.keymap.set('x', 'K', ':MoveUp<CR>', { silent = true })
vim.keymap.set('x', 'J', ':MoveDown<CR>', { silent = true })

-- For compatibility with indent-blankline.nvim:
vim.keymap.set('x', '<', indent_wrap_mapping('<'), { silent = true })
vim.keymap.set('x', '>', indent_wrap_mapping('>'), { silent = true })
