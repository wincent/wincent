-- Attempts to `require` and return the module identified by `name`.
--
-- Returns `nil` in the event of an error.
local safe_require = function(name)
  local has_module, required = pcall(require, name)

  return has_module and required or nil
end

return safe_require
