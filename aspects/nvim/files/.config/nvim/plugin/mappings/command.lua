--
-- Command mode mappings.
--

local rhs = wincent.vim.rhs

local is_search = function()
  local cmdtype = vim.fn.getcmdtype()
  return cmdtype == '/' or cmdtype == '?'
end

vim.keymap.set('c', '<C-a>', '<Home>')
vim.keymap.set('c', '<C-e>', '<End>')

-- `<Tab>`/`<S-Tab>` to move between matches without leaving incremental search.
-- Note dependency on `'wildcharm'` being set to `<C-z>` in order for this to
-- work.
vim.keymap.set('c', '<Tab>', function()
  if is_search() then
    return rhs('<CR>/<C-r>/')
  else
    return rhs('<C-z>')
  end
end, { expr = true })

vim.keymap.set('c', '<S-Tab>', function()
  if is_search() then
    return rhs('<CR>?<C-r>/')
  else
    return rhs('<S-Tab>')
  end
end, { expr = true })

-- These rely on Option-Left and Option-Right being set to send these escape
-- sequences in the iTerm2 preferences. See `:help tcsh-style`.
vim.keymap.set('c', '<A-b>', '<S-Left>')
vim.keymap.set('c', '<A-f>', '<S-Right>')
