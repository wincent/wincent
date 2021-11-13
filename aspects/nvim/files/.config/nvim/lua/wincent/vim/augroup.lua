wincent.g.augroup_callbacks = {}

-- Encapsulates the common pattern of creating (or redeclaring) an augroup,
-- clearing it, and populating it with autocommands.
local augroup = function (name, callback)
  vim.cmd('augroup ' .. name)
  vim.cmd('autocmd!')
  callback()
  vim.cmd('augroup END')

  -- Allows us to hackily re-register the same group of autocmds in the future.
  wincent.g.augroup_callbacks[name] = callback
end

return augroup
