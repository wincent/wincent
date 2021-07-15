local map = wincent.vim.map

local imap = function (lhs, rhs, opts)
  opts = opts or {}
  map('i', lhs, rhs, opts)
end

return imap
