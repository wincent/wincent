local autocmd = wincent.vim.autocmd

wincent.g.augroup_callbacks = {}

-- Encapsulates the common pattern of creating (or redeclaring) an augroup,
-- clearing it, and populating it with autocommands.
local augroup = function(group_name, callback)
  vim.api.nvim_create_augroup(group_name, { clear = true })

  callback(function(autocmd_name, pattern, cmd, opts)
    autocmd(autocmd_name, pattern, cmd, vim.tbl_extend('keep', { group = group_name }, opts or {}))
  end)

  -- Allows us to hackily re-register the same group of autocmds in the future.
  wincent.g.augroup_callbacks[group_name] = callback
end

return augroup
