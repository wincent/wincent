local map = wincent.vim.map
local shallow_merge = wincent.util.shallow_merge

local nnoremap = function (lhs, rhs, opts)
  opts = opts or {}
  return map('n', lhs, rhs, shallow_merge(opts, {noremap = true}))
end

return nnoremap
