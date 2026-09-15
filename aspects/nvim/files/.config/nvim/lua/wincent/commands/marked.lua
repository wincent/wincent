local open = require('wincent.commands.open')

--- Previews `file` (defaulting to the current file) in Marked 2.
---
--- @param file? string
local function marked(file)
  if file == nil or file == '' then
    file = vim.fn.expand('%')
  end

  -- TODO: remove this hack once new version of Marked 2 is out:
  -- http://support.markedapp.com/discussions/questions/8670
  vim.fn.system({ 'xattr', '-d', 'com.apple.quarantine', file })

  open('Marked 2.app', file)
end

return marked
