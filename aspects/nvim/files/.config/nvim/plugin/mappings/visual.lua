-- Visual mode mappings.

local xnoremap = wincent.vim.xnoremap

-- Move between windows.
xnoremap('<C-h>', '<C-w>h')
xnoremap('<C-j>', '<C-w>j')
xnoremap('<C-k>', '<C-w>k')
xnoremap('<C-l>', '<C-w>l')

-- Move VISUAL LINE selection within buffer.
vim.cmd('command! -range MoveDown call v:lua.wincent.mappings.visual.move_down(<line2>)')
vim.cmd('command! -range MoveUp call v:lua.wincent.mappings.visual.move_up(<line1>)')

xnoremap('K', ':MoveUp<CR>', {silent = true})
xnoremap('J', ':MoveDown<CR>', {silent = true})
