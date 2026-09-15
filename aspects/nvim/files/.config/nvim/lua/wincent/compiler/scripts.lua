--- Returns the "scripts" section of the nearest enclosing "package.json", or an
--- empty table if there isn't one (or it can't be read, or it is malformed).
---
--- @return table<string, string>
local function scripts()
  local root = vim.fs.root(0, 'package.json')

  if root == nil then
    return {}
  end

  local ok, data = pcall(function()
    return vim.json.decode(table.concat(vim.fn.readfile(root .. '/package.json'), '\n'))
  end)

  if not ok or type(data) ~= 'table' or type(data.scripts) ~= 'table' then
    -- Oh well, it was worth a try...
    return {}
  end

  return data.scripts
end

return scripts
