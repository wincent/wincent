local map = wincent.vim.map

local xmap = function (lhs, rhs, opts)
  opts = opts or {}
  map('x', lhs, rhs, opts)
end

return xmap
