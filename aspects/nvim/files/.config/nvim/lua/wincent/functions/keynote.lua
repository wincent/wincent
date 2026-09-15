--- Opens a syntax-colored version of the current file in Chrome, suitable for
--- copy-pasting into a presentation.
local function keynote()
  vim.cmd.packadd('nvim.tohtml')

  local html = require('tohtml').tohtml(0, { font = 'MonoLisa' })
  local tempfile = vim.fn.tempname() .. '.html'

  vim.fn.writefile(html, tempfile)

  vim.notify(tempfile)

  vim.fn.system({ 'open', '-b', 'com.google.Chrome', tempfile })
end

return keynote
