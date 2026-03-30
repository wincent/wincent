-- TODO: complete `find` arg names too
-- TODO: check escaping (q-args) is correct
vim.api.nvim_create_user_command('Find', 'call wincent#commands#find(<q-args>)', { complete = 'file', nargs = '*' })

vim.api.nvim_create_user_command('Lint', 'call wincent#commands#lint()', {})

vim.api.nvim_create_user_command('Typecheck', 'call wincent#commands#typecheck()', {})
vim.api.nvim_create_user_command('Vim', 'call wincent#commands#vim()', {})

-- Markdown previews.
vim.api.nvim_create_user_command('Glow', 'call wincent#commands#glow(<q-args>)', { complete = 'file', nargs = '?' })
vim.api.nvim_create_user_command('Marked', 'call wincent#commands#marked(<q-args>)', { complete = 'file', nargs = '?' })
vim.api.nvim_create_user_command(
  'Preview',
  'call wincent#commands#preview(<q-args>)',
  { complete = 'file', nargs = '?' }
)
