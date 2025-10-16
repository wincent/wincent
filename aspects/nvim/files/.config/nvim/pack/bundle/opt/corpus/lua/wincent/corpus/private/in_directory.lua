-- Copyright 2015-present Greg Hurrell. All rights reserved.
-- Licensed under the terms of the MIT license.

local directories = require('wincent.corpus.private.directories')

local in_directory = function()
  local cwd = vim.fn.getcwd()
  return vim.tbl_contains(directories(), cwd)
end

return in_directory
