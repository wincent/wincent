-- Copyright 2015-present Greg Hurrell. All rights reserved.
-- Licensed under the terms of the MIT license.

local title_for_file = function(file)
  return vim.fn.fnamemodify(file, ':t:r')
end

return title_for_file
