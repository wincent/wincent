local autocmd = require('wincent.nvim.autocmd')

autocmd('BufNewFile,BufRead', 'differential-update-comments,new-commit', 'set filetype=arc')
