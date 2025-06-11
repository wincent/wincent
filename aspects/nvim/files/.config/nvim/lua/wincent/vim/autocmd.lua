-- Wrapper for simple autocmd use cases. `cmd` may be a string containing an EX
-- command (see `:h Ex-commands`) or a Lua function.
local function autocmd(name, pattern, cmd, opts)
  opts = opts or {}
  local events = vim.split(vim.trim(name), ',')
  vim.api.nvim_create_autocmd(events, {
    callback = type(cmd) == 'function' and cmd or nil,
    command = type(cmd) == 'string' and cmd or nil,
    group = opts.group,
    once = not not opts.once,
    pattern = pattern,
  })
end

return autocmd
