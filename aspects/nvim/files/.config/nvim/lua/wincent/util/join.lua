local join = function(tbl, delimiter)
  delimiter = delimiter or ''
  local result = ''
  local len = #tbl
  for i, item in ipairs(tbl) do
    if i == len then
      result = result .. item
    else
      result = result .. item .. delimiter
    end
  end
  return result
end

return join
