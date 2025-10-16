-- Copyright 2015-present Greg Hurrell. All rights reserved.
-- Licensed under the terms of the MIT license.

local util = {}

local mt = {
  __index = function(tbl, key)
    if util[key] == nil then
      util[key] = require('wincent.corpus.private.util.' .. key)
    end
    return util[key]
  end,
}

return setmetatable({}, mt)
