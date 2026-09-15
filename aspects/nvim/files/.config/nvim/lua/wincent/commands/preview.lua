--- Previews `file` (defaulting to the current file) using whichever previewer
--- is available.
---
--- @param file? string
local function preview(file)
  if vim.fn.executable('open') == 1 then
    require('wincent.commands.marked')(file)
  elseif vim.fn.executable('glow') == 1 then
    require('wincent.commands.glow')(file)
  else
    vim.notify('No "open" or "glow" executable found', vim.log.levels.ERROR)
  end
end

return preview
