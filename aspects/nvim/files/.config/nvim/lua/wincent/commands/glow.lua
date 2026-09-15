--- Previews `file` (defaulting to the current file) with `glow`, in a
--- Dispatch-spawned pager.
---
--- @param file? string
local function glow(file)
  if vim.fn.executable('glow') ~= 1 then
    vim.notify('No glow executable found', vim.log.levels.ERROR)
    return
  end

  if file == nil or file == '' then
    file = vim.fn.expand('%')
  end

  if file ~= '' then
    file = vim.fn.shellescape(file)
  end

  -- Make sure LESS doesn't include the problematic `F` option, which
  -- causes the pager to exit immediately if output fits on less than one
  -- screen.
  --
  -- Note: no `--local`. Glow v2 removed non-local mode (and therefore the
  -- flag); passing it to v3 is a hard error.
  vim.cmd('Spawn env LESS="-iMRX" glow --pager ' .. file)
end

return glow
