--
-- Basic recursive equality checker.
--

local function deepEquals(a, b)
  local typeA = type(a)
  local typeB = type(b)
  if typeA ~= typeB then
    return false
  end
  if typeA ~= 'table' then
    return a == b
  end
  local meta = getmetatable(a)
  if meta and meta.__eq then
    return a == b
  end
  for k, v in pairs(a) do
    local other = b[k]
    if other == nil or not deepEquals(v, other) then
      return false
    end
  end
  for k, v in pairs(b) do
    local other = a[k]
    if other == nil or not deepEquals(v, other) then
      return false
    end
  end
  return true
end

return deepEquals
