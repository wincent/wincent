local autocmd = wincent.vim.autocmd
local setlocal = wincent.vim.setlocal

-- Switch to plaintext mode with: call wincent#functions#plaintext()
local plaintext = function()
  setlocal('concealcursor', 'nc')
  setlocal('list', false)
  setlocal('textwidth', 0)
  setlocal('wrap')
  setlocal('wrapmargin', 0)

  wincent.vim.spell()

  -- Break undo sequences into chunks (after punctuation); see: `:h i_CTRL-G_u`
  --
  -- From:
  --
  --   https://twitter.com/vimgifs/status/913390282242232320
  --
  -- Via:
  --
  --   https://github.com/ahmedelgabri/dotfiles/blob/f2b74f6cd4d/files/.vim/plugin/mappings.vim#L27-L33
  --
  vim.keymap.set('i', '!', '!<C-g>u', { buffer = true })
  vim.keymap.set('i', ',', ',<C-g>u', { buffer = true })
  vim.keymap.set('i', '.', '.<C-g>u', { buffer = true })
  vim.keymap.set('i', ':', ':<C-g>u', { buffer = true })
  vim.keymap.set('i', ';', ';<C-g>u', { buffer = true })
  vim.keymap.set('i', '?', '?<C-g>u', { buffer = true })

  vim.keymap.set('n', 'j', 'gj', { buffer = true })
  vim.keymap.set('n', 'k', 'gk', { buffer = true })

  -- Ideally would keep 'list' set, and restrict 'listchars' to just
  -- show whitespace errors, but 'listchars' is global and I don't want
  -- to go through the hassle of saving and restoring.
  autocmd('BufWinEnter', '<buffer>', 'match Error /\\s\\+$/')
  autocmd('InsertEnter', '<buffer>', 'match Error /\\s\\+\\%#\\@<!$/')
  autocmd('InsertLeave', '<buffer>', 'match Error /\\s\\+$/')
  autocmd('BufWinLeave', '<buffer>', 'call clearmatches()')
end

return plaintext
