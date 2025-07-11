local autocmd = require('wincent.nvim.autocmd')

-- https://bnd.bndtools.org/md/805-instructions.html
autocmd('BufNewFile,BufRead', '*.bnd', 'set filetype=bnd')
