-- Copyright 2015-present Greg Hurrell. All rights reserved.
-- Licensed under the terms of the MIT license.

local util = {
  list = {},
}

-- Peforms a shallow clone of `list`.
util.list.clone = function(list)
  return { unpack(list) }
end

-- Concatenates `list` with `other` (also a list), returning a new list.
util.list.concat = function(list, other)
  local result = util.list.clone(list)
  for _, v in ipairs(other) do
    table.insert(result, v)
  end
  return result
end

util.list.filter = function(list, cb)
  local result = {}
  for i, v in ipairs(list) do
    if cb(v, i) then
      table.insert(result, v)
    end
  end
  return result
end

-- Maps over `list`, returning a new list.
util.list.map = function(list, cb)
  local result = {}
  for i, v in ipairs(list) do
    result[i] = cb(v, i)
  end
  return result
end

-- Pushes one or more elements onto `list`, mutating it.
util.list.push = function(list, ...)
  for _, v in ipairs({ ... }) do
    table.insert(list, v)
  end
end

return util.list
