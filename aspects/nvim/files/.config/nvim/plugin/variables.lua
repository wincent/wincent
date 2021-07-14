-- Quick/essential variables which must be loaded immediately.
wincent.variables.eager()

-- Slow/nice-to-have variables which can be loaded when idle.
vim.defer_fn(wincent.variables.idle, 0)
