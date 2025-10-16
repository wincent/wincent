-- Copyright 2015-present Greg Hurrell. All rights reserved.
-- Licensed under the terms of the MIT license.

local config = require('wincent.corpus.private.config')
local normalize = require('wincent.corpus.private.normalize')

-- Returns directory-specific config for `file`, or an empty table if `file`
-- is not in one of the Corpus directories.
local config_for_file = function(file)
  local base = vim.fn.fnamemodify(file, ':h')
  local directories = config.corpus_directories
  for directory, settings in pairs(directories) do
    local candidate = normalize(directory)
    if candidate == base then
      return vim.tbl_extend('force', { location = candidate }, settings)
    end
  end
  return vim.empty_dict()
end

return config_for_file
