wincent.g.map_callbacks = {}

-- Used as tie-breaker in event that multiple registrations happen for same file
-- + line.
local callback_index = 0

local config_prefix = vim.env.HOME .. '/.config/nvim/'

-- TODO: For completeness, should have unmap() too, and other variants
-- as they arise (nunmap() etc); but for now just going with a "dispose"
-- function as return value.

local get_key = function (fn)
  local info = debug.getinfo(fn)
  local key = info.short_src
  if vim.startswith(key, config_prefix) then
    key = key:sub(#config_prefix + 1)
  end
  if vim.endswith(key, '.lua') then -- and sure would be weird if it _didn't_
    key = key:sub(1, #key - 4)
  end
  key = key:gsub('%W', '_')
  key = key .. '_L' .. info.linedefined
  if wincent.g.map_callbacks[key] ~= nil then
    key = key .. '_' .. callback_index
    callback_index = callback_index + 1
  end
  return key
end

local map = function (mode, lhs, rhs, opts)
  opts = opts or {}
  local rhs_type = type(rhs)
  if rhs_type == 'function' then
    local key = get_key(rhs)
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

  return {
    dispose = function()
      if buffer == true then
        vim.api.nvim_buf_del_keymap(0, mode, lhs)
      else
        vim.api.nvim_del_keymap(mode, lhs)
      end
      wincent.g.map_callbacks[key] = nil
    end,
  }
end

return map
