local nnoremap = wincent.vim.nnoremap

-- Grow/shrink window horizontally (ie. make wider or narrower).
nnoremap('<Leader>=', ':vertical resize +5<CR>', {silent = true})
nnoremap('<Leader>-', ':vertical resize -5<CR>', {silent = true})

-- Grow/shrink window vertically (ie. make taller or shorter).
nnoremap('<LocalLeader>=', ':resize +5<CR>', {silent = true})
nnoremap('<LocalLeader>-', ':resize -5<CR>', {silent = true})
