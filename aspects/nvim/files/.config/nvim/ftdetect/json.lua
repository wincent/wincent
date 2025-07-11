local autocmd = require('wincent.nvim.autocmd')

autocmd('BufNewFile,BufRead', '.eslintrc', 'set filetype=json')
