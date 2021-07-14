vim.defer_fn(wincent.plugins.abolish, 0)

vim.fn['wincent#plugin#lazy']({
  pack = 'undotree',
  plugin = 'undotree.vim',
  nnoremap = {
    ['<silent> <Leader>u'] = ':UndotreeToggle<CR>',
  },
  beforeload = {
    'call wincent#undotree#init()',
  }
})
