wincent.g.autocommand_callbacks = {}

local callback_index = 0

-- Wrapper for simple autocmd use cases. `cmd` may be a string or a Lua
-- function.
local autocmd = function (name, pattern, cmd)
  local cmd_type = type(cmd)
  if cmd_type == 'function' then
    local key = '_' .. callback_index
    callback_index = callback_index + 1
    wincent.g.autocommand_callbacks[key] = cmd
    cmd = 'lua wincent.g.autocommand_callbacks.' .. key .. '()'
  elseif cmd_type ~= 'string' then
    error('autocmd(): unsupported cmd type: ' .. cmd_type)
  end
  vim.cmd('autocmd ' .. name .. ' ' .. pattern .. ' ' .. cmd)
end

return autocmd
