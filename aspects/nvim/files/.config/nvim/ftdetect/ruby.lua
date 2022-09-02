local patterns = table.concat({
  '.pryrc',
  'Guardfile',
  'pryrc',
}, ',')

wincent.vim.autocmd('BufNewFile,BufRead', patterns, 'set filetype=ruby')
