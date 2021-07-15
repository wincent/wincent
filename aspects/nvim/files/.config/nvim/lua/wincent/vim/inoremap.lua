local map = wincent.vim.map
local shallow_merge = wincent.util.shallow_merge

local inoremap = function (lhs, rhs, opts)
  opts = opts or {}
  map('i', lhs, rhs, shallow_merge(opts, {noremap = true}))
end

return inoremap
