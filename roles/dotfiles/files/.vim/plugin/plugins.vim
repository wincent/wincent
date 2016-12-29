call defer#defer('call plugins#abolish()')

call plugin#lazy({
      \   'pack': 'undotree',
      \   'plugin': 'undotree',
      \   'nnoremap': ['<silent> <Leader>u', ':UndotreeToggle<CR>'],
      \   'onload': [
      \     'call after#undotree#init()',
      \     'UndotreeToggle'
      \   ]
      \ })
