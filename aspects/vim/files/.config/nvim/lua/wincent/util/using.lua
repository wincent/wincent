-- Pattern for safely using a module that may not be present.
--
--    using('compe', function (compe)
--      print('only executed if compe is available')
--    end)
local using = function(name, callback)
  local has_module, required = pcall(require, name)

  if has_module then
    return callback(required)
  end
end

return using
