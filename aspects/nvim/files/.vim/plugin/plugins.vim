call wincent#defer#defer('call wincent#plugins#abolish()')

call wincent#plugin#lazy({
      \   'pack': 'undotree',
      \   'plugin': 'undotree.vim',
      \   'nnoremap': {
      \     '<silent> <Leader>u': ':UndotreeToggle<CR>'
      \   },
      \   'beforeload': [
      \     'call wincent#undotree#init()'
      \   ]
      \ })
