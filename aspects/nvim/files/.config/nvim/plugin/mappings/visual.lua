--
-- Visual mode mappings.
--

local command = wincent.vim.command
local xnoremap = wincent.vim.xnoremap

-- Move between windows.
xnoremap('<C-h>', '<C-w>h')
xnoremap('<C-j>', '<C-w>j')
xnoremap('<C-k>', '<C-w>k')
xnoremap('<C-l>', '<C-w>l')

-- Move VISUAL LINE selection within buffer.
command('MoveDown', 'call v:lua.wincent.mappings.visual.move_down(<line2>)', {range = true})
command('MoveUp', 'call v:lua.wincent.mappings.visual.move_up(<line1>)', {range = true})

xnoremap('K', ':MoveUp<CR>', {silent = true})
xnoremap('J', ':MoveDown<CR>', {silent = true})
