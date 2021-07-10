-- Encapsulates the common pattern of creating (or redeclaring) an augroup,
-- clearing it, and populating it with autocommands.
local augroup = function (name, callback)
  vim.cmd('augroup ' .. name)
  vim.cmd('autocmd!')
  callback()
  vim.cmd('augroup END')
end

return augroup
