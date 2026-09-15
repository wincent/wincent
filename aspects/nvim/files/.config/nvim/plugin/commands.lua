local command = vim.api.nvim_create_user_command

-- TODO: complete `find` arg names too
command('Find', function(opts)
  require('wincent.commands.find')(opts.args)
end, { complete = 'file', nargs = '*' })

command('Lint', function()
  require('wincent.commands.lint')()
end, {})

command('Typecheck', function()
  require('wincent.commands.typecheck')()
end, {})

command('Vim', function()
  require('wincent.commands.vim')()
end, {})

-- Markdown previews.
command('Glow', function(opts)
  require('wincent.commands.glow')(opts.args)
end, { complete = 'file', nargs = '?' })

command('Marked', function(opts)
  require('wincent.commands.marked')(opts.args)
end, { complete = 'file', nargs = '?' })

command('Preview', function(opts)
  require('wincent.commands.preview')(opts.args)
end, { complete = 'file', nargs = '?' })
