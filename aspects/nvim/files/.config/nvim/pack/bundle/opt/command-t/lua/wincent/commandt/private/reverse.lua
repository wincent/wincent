-- SPDX-FileCopyrightText: Copyright 2026-present Greg Hurrell and contributors.
-- SPDX-License-Identifier: BSD-2-Clause

--- Reverses `list` in place.
---
--- @param list any[]
--- @return nil
local function reverse(list)
  local i = 1
  local j = #list
  while i < j do
    list[i], list[j] = list[j], list[i]
    i = i + 1
    j = j - 1
  end
end

return reverse
