local command = wincent.vim.command

-- TODO: complete `find` arg names too
-- TODO: check escaping (q-args) is correct
command('Find', 'call wincent#commands#find(<q-args>)', { complete = 'file', nargs = '*' })

command('Lint', 'call wincent#commands#lint()')

command('OpenOnGitHub', function(options)
  vim.notify(':OpenOnGitHub is deprecated. Use :GBrowse instead.', vim.log.levels.WARN)
  local has_fugitive = wincent.plugin.is_loaded('vim-fugitive')
  local has_rhubarb = wincent.plugin.is_loaded('vim-rhubarb')
  if not has_fugitive then
    vim.notify('vim-fugitive is not active.', vim.log.levels.ERROR)
  end
  if not has_rhubarb then
    vim.notify('vim-rhubarb is not active.', vim.log.levels.ERROR)
  end
  if has_fugitive and has_rhubarb then
    -- Using `pcall()` to suppress the ugly stack trace that `vim.cmd()` will
    -- spit out if fugitive does an `:echoerr "fugitive: can't browse to
    -- unpushed change"`. (Only `vim.cmd()` does this; you see just the error
    -- message without a stack trace when calling `:GBrowse` directly.)
    local success, error = pcall(function()
      if options.range == 1 then
        vim.cmd(options.line1 .. 'GBrowse ' .. (options.args or ''))
      elseif options.range == 2 then
        vim.cmd(options.line1 .. ',' .. options.line2 .. 'GBrowse ' .. (options.args or ''))
      else
        vim.cmd('GBrowse ' .. (options.args or ''))
      end
    end)
    if not success and error ~= nil then
      vim.notify(tostring(error), vim.log.levels.ERROR)
    end
  end
end, {
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
