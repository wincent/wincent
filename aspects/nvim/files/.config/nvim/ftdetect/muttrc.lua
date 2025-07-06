local autocmd = require('wincent.nvim.autocmd')

autocmd('BufNewFile,BufRead', '*.mutt', 'set filetype=muttrc')
