local autocmd = require('wincent.nvim.autocmd')

autocmd('BufNewFile,BufRead', '*/.config/git/host/*', 'set filetype=gitconfig')
