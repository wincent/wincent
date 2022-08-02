-- New extensions: https://www.typescriptlang.org/docs/handbook/esm-node.html#new-file-extensions
wincent.vim.autocmd('BufNewFile,BufRead', '*.cts,*.mts', 'noautocmd set filetype=typescript')
