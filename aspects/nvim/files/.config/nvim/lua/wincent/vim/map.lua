wincent.g.map_callbacks = {}

local callback_index = 0

-- TODO: For completeness, should have unmap() too, and other variants as they
-- arise.

local map = function (mode, lhs, rhs, opts)
  opts = opts or {}
  local rhs_type = type(rhs)
  if rhs_type == 'function' then
    local key = '_' .. callback_index
    callback_index = callback_index + 1
    wincent.g.map_callbacks[key] = rhs
    rhs = 'v:lua.wincent.g.map_callbacks.' .. key .. '()'
  elseif rhs_type ~= 'string' then
    error('map(): unsupported rhs type: ' .. rhs_type)
  end
  local buffer = opts.buffer
  opts.buffer = nil
  if buffer == true then
    vim.api.nvim_buf_set_keymap(0, mode, lhs, rhs, opts)
  else
    vim.api.nvim_set_keymap(mode, lhs, rhs, opts)
  end
end

return map
