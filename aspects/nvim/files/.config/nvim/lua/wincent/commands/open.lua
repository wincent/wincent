--- Opens `file` with macOS' `open(1)`, using the named application.
---
--- @param app string
--- @param file string
local function open(app, file)
  if vim.fn.executable('open') ~= 1 then
    vim.notify('No "open" executable', vim.log.levels.ERROR)
    return
  end

  vim.fn.system({ 'open', '-a', app, file })
end

return open
