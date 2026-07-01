local autocmd = require('wincent.nvim.autocmd')

autocmd('BufNewFile,BufRead', '.eslintignore,.prettierignore,.styluaignore', 'set filetype=gitignore')
