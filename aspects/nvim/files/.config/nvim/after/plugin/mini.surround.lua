local has_surround, surround = pcall(require, 'mini.surround')
if has_surround then
  -- Configure to match tpope/vim-surround behavior
  -- (see `:h MiniSurround-vim-surround-config`).
  surround.setup({
    mappings = {
      add = 'ys',
      delete = 'ds',
      replace = 'cs',
      find = '',
      find_left = '',
      highlight = '',
      suffix_last = '',
      suffix_next = '',
      update_n_lines = '',
    },
    search_method = 'cover_or_next',
  })

  -- (VISUAL) `S` adds surrounding to Visual mode selection.
  vim.keymap.del('x', 'ys')
  vim.keymap.set('x', 'S', [[:<C-u>lua MiniSurround.add('visual')<CR>]], { silent = true })

  -- (NORMAL) `yss` adds surrounding to entire line.
  vim.keymap.set('n', 'yss', 'ys_', { remap = true })
end
