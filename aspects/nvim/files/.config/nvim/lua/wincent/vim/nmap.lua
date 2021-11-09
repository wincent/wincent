local map = wincent.vim.map

local nmap = function (lhs, rhs, opts)
  opts = opts or {}
  return map('n', lhs, rhs, opts)
end

return nmap
