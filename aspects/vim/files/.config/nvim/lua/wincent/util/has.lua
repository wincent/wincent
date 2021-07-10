-- Returns `true` if the module identified by `name` can be imported
-- with `require`; eg:
--
-- if has('compe') then
--   local compe = require'compe'
-- end
local has = function(name)
  local has_module, _ = pcall(require, name)
  return not not has_module
end

return util
