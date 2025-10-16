-- Copyright 2015-present Greg Hurrell. All rights reserved.
-- Licensed under the terms of the MIT license.

-- Like 'smartcase', will be case-insensitive unless argument contains an
-- uppercase letter.
local smartcase = function(input)
  return input:match('%u') ~= nil
end

return smartcase
