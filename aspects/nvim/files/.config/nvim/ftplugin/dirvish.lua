-- Overwrite default mapping for the benefit of my muscle memory. ('o'
-- would normally open in a split window, but we want it to open in the
-- current one.)
wincent.vim.nnoremap('o', ":<C-U>.call dirvish#open('edit', 0)<CR>", { buffer = true, nowait = true, silent = true })

-- Seeing as wincent.colorcolumn_filetype_blacklist doesn't work for this:
wincent.vim.setlocal('colorcolumn', '')
