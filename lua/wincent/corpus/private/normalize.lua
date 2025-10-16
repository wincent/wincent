-- Copyright 2015-present Greg Hurrell. All rights reserved.
-- Licensed under the terms of the MIT license.

-- Turns `afile` into a simplified absolute path with all symlinks resolved.
-- If `afile` corresponds to a directory any trailing slash will be removed.
local normalize = function(afile)
  local file = afile
  if vim.startswith(file, '<') then
    file = vim.fn.expand(file)
  end
  file = vim.fn.resolve(vim.fn.fnamemodify(file, ':p'))
  if vim.endswith(file, '/') then
    return file:sub(0, file:len() - 1)
  else
    return file
  end
end

return normalize
