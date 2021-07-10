local wincent = require'wincent'

local map = wincent.vim.map

local smap = function (lhs, rhs, opts)
  map('s', lhs, rhs, opts)
end

return smap
