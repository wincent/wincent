-- Copyright 2015-present Greg Hurrell. All rights reserved.
-- Licensed under the terms of the MIT license.

local run = require('wincent.corpus.private.run')
local util = require('wincent.corpus.private.util')

local git = function(directory, ...)
  if vim.fn.isdirectory(directory) == 0 then
    error('Not a directory: ' .. directory)
  end
  if vim.fn.isdirectory(directory .. '/.git') == 0 then
    -- TODO: decide whether it's right to do this unconditionally like this
    run({ 'git', '-C', directory, 'init' })
  end

  local command = util.list.concat({ 'git', '-C', directory }, { ... })
  return run(command)
end

return git
