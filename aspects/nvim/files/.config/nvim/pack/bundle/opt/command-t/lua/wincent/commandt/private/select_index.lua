-- SPDX-FileCopyrightText: Copyright 2026-present Greg Hurrell and contributors.
-- SPDX-License-Identifier: BSD-2-Clause

-- Decide which result index should be selected after the match listing updates.
--
-- - `previous`: the previously-selected index, or `nil`.
-- - `count`: the number of results now available.
-- - `order`: `'reverse'` selects the best match at the bottom, otherwise at the
--   top.
-- - `query_changed`: `true` for a keystroke (jump to the best match), `false`
--   for a streaming refresh (preserve the user's position, clamped).
--
-- Returns the new selected index, or `nil` when there are no results.
local function select_index(previous, count, order, query_changed)
  if count == 0 then
    return nil
  elseif query_changed or previous == nil then
    return order == 'reverse' and count or 1
  else
    return math.min(previous, count)
  end
end

return select_index
