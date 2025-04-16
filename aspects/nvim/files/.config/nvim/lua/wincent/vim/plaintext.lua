-- Switch to plaintext mode with: `:lua wincent.vim.plaintext()`
local plaintext = function()
  vim.opt_local.concealcursor = 'nc'
  vim.opt_local.listchars = 'trail:•'
  vim.opt_local.textwidth = 0
  vim.opt_local.wrap = true
  vim.opt_local.wrapmargin = 0

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
end

return plaintext
