local util = {}

-- "Safe" version of `nvim_buf_get_var()` that returns `nil` if the
-- variable is not set.
util.buf_get_var = function(handle, name)
  local result
  pcall(function ()
    result = vim.api.nvim_buf_get_var(handle, name)
  end)
  return result
end

-- "Safe" version of `nvim_get_var()` that returns `nil` if the
-- variable is not set.
util.get_var = function(handle, name)
  local result
  pcall(function ()
    result = vim.api.nvim_get_var(handle, name)
  end)
  return result
end

-- "Safe" version of `nvim_tabpage_get_var()` that returns `nil` if the
-- variable is not set.
util.tabpage_get_var = function(handle, name)
  local result
  pcall(function ()
    result = vim.api.nvim_tabpage_get_var(handle, name)
  end)
  return result
end

-- "Safe" version of `nvim_win_get_var()` that returns `nil` if the
-- variable is not set.
util.win_get_var = function(handle, name)
  local result
  pcall(function ()
    result = vim.api.nvim_win_get_var(handle, name)
  end)
  return result
end

return util
