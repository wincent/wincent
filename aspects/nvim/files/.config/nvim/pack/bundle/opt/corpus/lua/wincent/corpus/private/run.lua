-- Copyright 2015-present Greg Hurrell. All rights reserved.
-- Licensed under the terms of the MIT license.

local util = require('wincent.corpus.private.util')

-- TODO: better name for the param here (it's more than just args; it is
-- command plus args)
local run = function(args)
  local command = table.concat(
    util.list.map(args, function(word)
      return vim.fn.shellescape(word)
    end),
    ' '
  )
  return vim.fn.systemlist(command)
end

return run
