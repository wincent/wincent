local command = wincent.vim.command

-- TODO: complete `find` arg names too
-- TODO: check escaping (q-args) is correct
command('Find', 'call wincent#commands#find(<q-args>)', { complete = 'file', nargs = '*' })

command('Lint', 'call wincent#commands#lint()')

local is_loaded = function(plugin)
  for _, candidate in ipairs(vim.opt.runtimepath:get()) do
    if plugin == candidate:sub(-#plugin) then
      return true
    end
  end
  return false
end

vim.api.nvim_create_user_command('OpenOnGitHub', function(options)
  vim.notify(':OpenOnGitHub is deprecated. Use :GBrowse instead.', vim.log.levels.WARN)
  local has_fugitive = is_loaded('vim-fugitive')
  local has_rhubarb = is_loaded('vim-rhubarb')
  if not has_fugitive then
    vim.notify('vim-fugitive is not active.', vim.log.levels.ERROR)
  end
  if not has_rhubarb then
    vim.notify('vim-rhubarb is not active.', vim.log.levels.ERROR)
  end
  if has_fugitive and has_rhubarb then
    if options.range == 1 then
      vim.cmd(options.line1 .. 'GBrowse ' .. (options.args or ''))
    elseif options.range == 2 then
      vim.cmd(options.line1 .. ',' .. options.line2 .. 'GBrowse ' .. (options.args or ''))
    else
      vim.cmd('GBrowse ' .. (options.args or ''))
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
