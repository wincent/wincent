-- Pattern for safely using a module that may not be present.
--
--    using('compe', 'luasnip', function (compe, luasnip)
--      print('only executed if compe and luasnip are available')
--    end)
local using = function(...)
  local names = {...}
  local callback = table.remove(names)
  local modules = {}
  for _, name in ipairs(names) do
    local has_module, required = pcall(require, name)
    if has_module then
      table.insert(modules, required)
    else
      return
    end
  end
  callback(unpack(modules))
end

return using
