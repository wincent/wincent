local nnoremap = wincent.vim.nnoremap

-- Micro-optimizating the slightly-hard-to-type-on-Colemak-but-very-useful `gv`.
nnoremap('<Leader>v', 'gv')

-- nvim-tree.lua
nnoremap('<LocalLeader>t', ':NvimTreeToggle<CR>', {silent = true})
nnoremap('<LocalLeader>f', ':NvimTreeFindFile<CR>', {silent = true})

-- Grow/shrink window horizontally (ie. make wider or narrower).
nnoremap('<Leader>=', ':vertical resize +5<CR>', {silent = true})
nnoremap('<Leader>-', ':vertical resize -5<CR>', {silent = true})

-- Grow/shrink window vertically (ie. make taller or shorter).
nnoremap('<LocalLeader>=', ':resize +5<CR>', {silent = true})
nnoremap('<LocalLeader>-', ':resize -5<CR>', {silent = true})
