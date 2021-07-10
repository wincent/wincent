local wincent = require'wincent'

local callback_index = 0

-- TODO: For completeness, should have unmap() too, and other variants as they
-- arise.

local map = function (mode, lhs, rhs, opts)
  local rhs_type = type(rhs)
  if rhs_type == 'function' then
    local key = '_' .. callback_index
    callback_index = callback_index + 1
    wincent.g.map_callbacks[key] = rhs
    rhs = 'v:lua.wincent.g.map_callbacks.' .. key .. '()'
  elseif rhs_type ~= 'string' then
    error('map(): unsupported rhs type: ' .. rhs_type)
  end
  vim.api.nvim_set_keymap(mode, lhs, rhs, opts)
end

return map
