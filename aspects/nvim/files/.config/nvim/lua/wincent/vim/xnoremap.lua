local map = wincent.vim.map
local shallow_merge = wincent.util.shallow_merge

local xnoremap = function (lhs, rhs, opts)
  opts = opts or {}
  return map('x', lhs, rhs, shallow_merge(opts, {noremap = true}))
end

return xnoremap
