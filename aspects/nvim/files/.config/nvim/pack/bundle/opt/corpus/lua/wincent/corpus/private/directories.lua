-- Copyright 2015-present Greg Hurrell. All rights reserved.
-- Licensed under the terms of the MIT license.

local config = require('wincent.corpus.private.config')
local normalize = require('wincent.corpus.private.normalize')
local util = require('wincent.corpus.private.util')

local directories = function()
  local dirs = vim.tbl_keys(config.corpus_directories)
  if table.getn(dirs) == 0 then
    vim.api.nvim_err_writeln('No Corpus directories configured - please call:')
    vim.api.nvim_err_writeln("require'wincent.corpus'{")
    vim.api.nvim_err_writeln('  directories = ...,')
    vim.api.nvim_err_writeln('}')
  end
  return util.list.map(dirs, function(directory)
    return normalize(directory)
  end)
end

return directories
