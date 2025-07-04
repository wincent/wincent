--- Produces a list of numbers from `lower` to `upper`, inclusively.
---
--- @param lower number
--- @param upper number
--- @return number[]
---
local function range(lower, upper)
  local result = {}
  for i = lower, upper do
    table.insert(result, i)
  end
  return result
end

return range
