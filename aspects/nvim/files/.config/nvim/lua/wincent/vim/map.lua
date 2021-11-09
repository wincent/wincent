wincent.g.map_callbacks = {}

-- TODO: For completeness, should have unmap() too, and other variants
-- as they arise (nunmap() etc); but for now just going with a "dispose"
-- function as return value.

local map = function (mode, lhs, rhs, opts)
  opts = opts or {}
  local rhs_type = type(rhs)
  local key
  if rhs_type == 'function' then
    key = wincent.util.get_key_for_fn(rhs, wincent.g.map_callbacks)
    wincent.g.map_callbacks[key] = rhs
    if opts.expr then
      rhs = 'v:lua.wincent.g.map_callbacks.' .. key .. '()'
    else
      rhs = ':lua wincent.g.map_callbacks.' .. key .. '()<CR>'
    end
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
      if key ~= nil then
        wincent.g.map_callbacks[key] = nil
      end
    end,
  }
end

return map
