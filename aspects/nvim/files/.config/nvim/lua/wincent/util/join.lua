--- Joins a list of strings or numbers.
---
--- @param tbl (string | number)[] List of strings or numbers to be joined.
--- @param separator? string Text to use as separator (defaults to `''`).
--- @return string
---
local function join(tbl, separator)
  separator = separator or ''
  local result = ''
  local len = #tbl
  for i, item in ipairs(tbl) do
    if i == len then
      result = result .. item
    else
      result = result .. item .. separator
    end
  end
  return result
end

return join
