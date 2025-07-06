local autocmd = require('wincent.nvim.autocmd')

autocmd('BufNewFile,BufRead', '*.applescript', 'set filetype=applescript')
