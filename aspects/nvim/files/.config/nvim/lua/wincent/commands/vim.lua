--- Opens the current file via the `vim://` URL scheme.
local function vim_()
  local filename = vim.fn.expand('%:p')

  if filename == '' then
    vim.notify('No current file', vim.log.levels.ERROR)
    return
  end

  -- Break up the string literal here to stop Vim from thinking it's a modeline
  -- and freaking out with:
  --
  --   E518: Unknown option: //'
  --
  -- (The hazard is in the file's text, so it survives the port to Lua.)
  local output = vim.fn.system({ 'open', 'vim' .. '://' .. filename })

  -- The old implementation discarded this, so a missing `vim://` protocol
  -- handler looked exactly like success.
  if vim.v.shell_error ~= 0 then
    vim.notify(vim.trim(output), vim.log.levels.ERROR)
  end
end

return vim_
