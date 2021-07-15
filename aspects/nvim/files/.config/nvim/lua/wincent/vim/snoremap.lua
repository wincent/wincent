local map = wincent.vim.map
local shallow_merge = wincent.util.shallow_merge

local snoremap = function (lhs, rhs, opts)
  opts = opts or {}
  map('s', lhs, rhs, shallow_merge(opts, {noremap = true}))
end

return snoremap
