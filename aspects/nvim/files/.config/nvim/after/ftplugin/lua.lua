if wincent.vim.is_large_buffer() then
  -- nvim-treesitter set-up in ~/.config/nvim/init.lua suppresses most
  -- treesitter functionality for large files (you can confirm this with
  -- :TSModuleInfo), but we still need this, to compensate the
  -- `vim.treesitter.start()` that happens unconditionally in
  -- `$VIMRUNTIME/ftplugin/lua.lua`.
  vim.treesitter.stop()

  -- Likewise we need this. The suppression merely replaces
  -- `nvim_treesitter#indent()` (slow) with `GetLuaIndent()` (slow);
  -- furthermore, we have to delay the operation because the order of events is
  -- actually this:
  --
  -- 1. This file is evaluated, where we'd like to set `'indentexpr'` to ''.
  -- 2. Callbacks in nvim-treesitter config run, resetting `'indentexpr'` to
  --    `GetLuaIndent()`
  -- 2. Our scheduled callback runs, actually setting `'indentexpr'` to ''.
  vim.schedule(function()
    vim.opt_local.indentexpr = ''
  end)

  -- This is probably isn't actually needed, but we may as well pull out all
  -- stops if we're tyring to make this fast.
  local has_ibl = pcall(require, 'ibl')
  if has_ibl then
    vim.cmd('IBLDisable')
  end

  -- This definitely is needed...
  vim.opt_local.syntax = 'OFF'
else
  -- Undo unwanted side-effects of `$VIMRUNTIME/ftplugin/lua.lua`.
  vim.opt_local.foldexpr = 'v:lua.wincent.foldexpr(v:lnum)'
end
