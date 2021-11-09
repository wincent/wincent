local map = wincent.vim.map

local xmap = function (lhs, rhs, opts)
  opts = opts or {}
  return map('x', lhs, rhs, opts)
end

return xmap
