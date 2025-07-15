-- Slow variables which can be loaded when idle.
vim.defer_fn(function()
  require('wincent.variables.idle')
end, 0)
