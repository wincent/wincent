local writefile = function(lines)
  vim.fn.writefile(lines, '/tmp/wincent-nvim-debug.txt', 'as')
end

-- TODO: extract this? it's the same as wincent.commandt.private.is_list()
local is_list = function(value)
  if type(value) ~= 'table' then
    return false
  elseif #value > 0 then
    return true
  else
    --- @diagnostic disable-next-line: unused-local
    for _k, _v in pairs(value) do
      return false
    end
  end
  --- @diagnostic disable-next-line: unreachable-code
  return true
end

local function debug(value)
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
