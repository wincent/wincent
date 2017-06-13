call wincent#defer#defer('call plugins#abolish()')

call plugin#lazy({
      \   'pack': 'undotree',
      \   'plugin': 'undotree.vim',
      \   'nnoremap': {
      \     '<silent> <Leader>u': ':UndotreeToggle<CR>'
      \   },
      \   'beforeload': [
      \     'call wincent#undotree#init()'
      \   ]
      \ })
