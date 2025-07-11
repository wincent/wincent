local autocmd = require('wincent.nvim.autocmd')

autocmd('BufNewFile,BufRead', '.pryrc,Guardfile,pryrc', 'set filetype=ruby')
