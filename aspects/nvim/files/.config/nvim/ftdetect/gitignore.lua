local autocmd = require('wincent.nvim.autocmd')

autocmd('BufNewFile,BufRead', '.agignore,.eslintignore,.prettierignore,.styluaignore', 'set filetype=gitignore')
