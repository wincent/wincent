local format = require('wincent.debug.format')
local logfile = require('wincent.debug.logfile')

--- Appends `...` to the log file, one line per value (and one line per line, for
--- multi-line values).
---
--- Strings are written as-is; everything else gets run through `vim.inspect()`.
--- Lists are flattened, so a list of strings can be used to write several lines
--- in one call.
---
--- @param ... any
local function log(...)
  local lines = format(...)

  if #lines > 0 then
    -- 'a' to append, 's' to fsync.
    vim.fn.writefile(lines, logfile(), 'as')
  end
end

return log
