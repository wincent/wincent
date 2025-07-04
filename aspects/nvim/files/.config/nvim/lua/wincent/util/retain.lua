wincent.g.retained = {}

--- Permanently stop `value` from getting garbage-collected.
---
--- @generic T
--- @param value T
--- @return T
local function retain(value)
  wincent.g.retained[#wincent.g.retained + 1] = value
  return value
end

return retain
