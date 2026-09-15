local format = require('wincent.debug.format')

--- Like `wincent.debug.log()`, but echoes to the screen (and to `:messages`)
--- instead of writing to a file.
---
--- Differs from `vim.print()` in that it applies the same formatting rules as
--- `wincent.debug.log()` (notably, list flattening), which makes it easy to
--- swap one for the other while debugging.
---
--- @param ... any
local function print(...)
  local lines = format(...)

  if #lines > 0 then
    vim.api.nvim_echo({ { table.concat(lines, '\n') } }, true, {})
  end
end

return print
