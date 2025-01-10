local debug = nil

local writefile = function(lines)
  vim.fn.writefile(lines, '/tmp/wincent-nvim-debug.txt', 'as')
end

-- TODO: extract this?
local is_list = function(value)
  if type(value) ~= 'table' then
    return false
  elseif #value > 0 then
    return true
  else
    for _k, _v in pairs(value) do
      return false
    end
  end
  return true
end

debug = function(value)
  if type(value) == 'string' then
    writefile({ value })
  elseif is_list(value) then
    for _, v in pairs(value) do
      debug(v)
    end
  else
    writefile({ vim.inspect(value) })
  end
end

return debug
