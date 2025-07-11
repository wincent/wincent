local autocmd = require('wincent.nvim.autocmd')

autocmd('BufNewFile,BufRead', '*.wikitext', 'set filetype=wikitext')
