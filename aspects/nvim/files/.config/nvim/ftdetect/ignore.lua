local autocmd = require('wincent.nvim.autocmd')

autocmd('BufNewFile,BufRead', '.eslintignore,.gitignore,.prettierignore', 'set filetype=ignore')
