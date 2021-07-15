local map = wincent.vim.map

local smap = function (lhs, rhs, opts)
  opts = opts or {}
  map('s', lhs, rhs, opts)
end

return smap
