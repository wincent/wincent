wincent.g.autocommand_callbacks = {}

-- Wrapper for simple autocmd use cases. `cmd` may be a string or a Lua
-- function.
local autocmd = function (name, pattern, cmd)
  local cmd_type = type(cmd)
  if cmd_type == 'function' then
    local key = wincent.util.get_key_for_fn(cmd, wincent.g.autocommand_callbacks)
    wincent.g.autocommand_callbacks[key] = cmd
    cmd = 'lua wincent.g.autocommand_callbacks.' .. key .. '()'
  elseif cmd_type ~= 'string' then
    error('autocmd(): unsupported cmd type: ' .. cmd_type)
  end
  vim.cmd('autocmd ' .. name .. ' ' .. pattern .. ' ' .. cmd)
end

return autocmd
