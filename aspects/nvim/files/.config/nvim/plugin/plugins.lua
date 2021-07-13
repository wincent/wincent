vim.defer_fn(function()
  local wincent = require'wincent'
  wincent.plugins.abolish()
end, 0)

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
