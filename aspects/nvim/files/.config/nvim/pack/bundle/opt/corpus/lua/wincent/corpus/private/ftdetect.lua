-- Copyright 2015-present Greg Hurrell. All rights reserved.
-- Licensed under the terms of the MIT license.

local config_for_file = require('wincent.corpus.private.config_for_file')
local normalize = require('wincent.corpus.private.normalize')

-- Adds 'corpus' to the 'filetype' if the current file is under a Corpus-managed
-- directory.
local ftdetect = function()
  local file = normalize('<afile>')
  local config = config_for_file(file)
  if next(config) ~= nil then
    local filetypes = vim.split(vim.bo.filetype, '.', true)
    if not vim.tbl_contains(filetypes, 'corpus') then
      vim.bo.filetype = vim.bo.filetype .. '.corpus'
    end
  end
end

return ftdetect
