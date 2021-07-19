local noremap = wincent.vim.noremap

noremap('{', ':keeppatterns ?^\\d<CR>', {buffer = true, silent = true})
noremap('}', ':keeppatterns /^\\d<CR>', {buffer = true, silent = true})
