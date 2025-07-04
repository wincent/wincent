local patterns = table.concat({
  '.pryrc',
  'Guardfile',
  'pryrc',
}, ',')

wincent.nvim.autocmd('BufNewFile,BufRead', patterns, 'set filetype=ruby')
