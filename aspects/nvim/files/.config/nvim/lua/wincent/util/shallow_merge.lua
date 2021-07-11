-- Shallow table merge, merges `source` into `dest`, returning a copy (the
-- original tables are not modified).
local shallow_merge = function (dest, source)
  return vim.tbl_extend('force', dest, source)
end

return shallow_merge
