local map = wincent.vim.map

local imap = function (lhs, rhs, opts)
  map('i', lhs, rhs, opts)
end

return imap
