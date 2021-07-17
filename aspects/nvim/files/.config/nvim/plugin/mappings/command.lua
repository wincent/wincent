--
-- Command mode mappings.
--

local cnoremap = wincent.vim.cnoremap
local rhs = wincent.vim.rhs

local is_search = function()
  local cmdtype = vim.fn.getcmdtype()
  return cmdtype == '/' or cmdtype == '?'
end

cnoremap('<C-a>', '<Home>')
cnoremap('<C-e>', '<End>')

-- `<Tab>`/`<S-Tab>` to move between matches without leaving incremental search.
-- Note dependency on `'wildcharm'` being set to `<C-z>` in order for this to
-- work.
cnoremap(
  '<Tab>',
  (function ()
    if is_search() then
      return rhs('<CR>/<C-r>/')
    else
      return rhs('<C-z>')
    end
  end),
  {expr = true}
)

cnoremap(
  '<S-Tab>',
  (function ()
    if is_search() then
      return rhs('<CR>?<C-r>/')
    else
      return rhs('<S-Tab>')
    end
  end),
  {expr = true}
)

-- These rely on Option-Left and Option-Right being set to send these escape
-- sequences in the iTerm2 preferences. See `:help tcsh-style`.
cnoremap('<A-b>', '<S-Left>')
cnoremap('<A-f>', '<S-Right>')
