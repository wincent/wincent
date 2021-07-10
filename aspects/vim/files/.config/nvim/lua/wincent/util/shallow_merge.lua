-- Shallow table merge, merges `source` into `dest`, mutating it.
--
-- Returns the modified `dest` table.
local shallow_merge = function (dest, source)
  for k, v in pairs(source) do
    dest[k] = v
  end
  return dest
end

return shallow_merge
