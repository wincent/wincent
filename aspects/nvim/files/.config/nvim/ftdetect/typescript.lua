local autocmd = require('wincent.nvim.autocmd')

-- New extensions: https://www.typescriptlang.org/docs/handbook/esm-node.html#new-file-extensions
autocmd('BufNewFile,BufRead', '*.cts,*.mts', 'noautocmd set filetype=typescript')
