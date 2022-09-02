local command = wincent.vim.command

-- TODO: complete `find` arg names too
-- TODO: check escaping (q-args) is correct
command('Find', 'call wincent#commands#find(<q-args>)', { complete = 'file', nargs = '*' })

command('Lint', 'call wincent#commands#lint()')
command('OpenOnGitHub', '<line1>,<line2>call wincent#commands#open_on_github(<f-args>)', {
  complete = 'file',
  nargs = '*',
  range = true,
})
command('Typecheck', 'call wincent#commands#typecheck()')
command('Vim', 'call wincent#commands#vim()')

-- Markdown previews.
command('Glow', 'call wincent#commands#glow(<q-args>)', { complete = 'file', nargs = '?' })
command('Marked', 'call wincent#commands#marked(<q-args>)', { complete = 'file', nargs = '?' })
command('Preview', 'call wincent#commands#preview(<q-args>)', { complete = 'file', nargs = '?' })
