-- SPDX-FileCopyrightText: Copyright 2026-present Greg Hurrell and contributors.
-- SPDX-License-Identifier: BSD-2-Clause

-- Format a non-negative integer with thousands separators (eg. 706248 becomes
-- "706,248").
local function group_thousands(n)
  local result = tostring(n)
  while true do
    local count
    result, count = result:gsub('^(%d+)(%d%d%d)', '%1,%2')
    if count == 0 then
      break
    end
  end
  return result
end

return group_thousands
