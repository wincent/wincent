-- Copyright 2015-present Greg Hurrell. All rights reserved.
-- Licensed under the terms of the MIT license.

local directories = require('wincent.corpus.private.directories')
local in_directory = require('wincent.corpus.private.in_directory')

-- If current working directory is a configured Corpus directory, returns it.
-- Otherwise, returns the first found default.
local directory = function()
  if in_directory() then
    return vim.fn.getcwd()
  else
    return directories()[1]
  end
end

return directory
