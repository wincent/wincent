wincent.g.lazy = {}

local lazy_index = 0

local lazy = function(config)
  config = vim.deepcopy(config)

  -- As a convenience, accept: {'CommandA', 'CommandB'}
  -- and transform it into: {CommandA = true, CommandB = true}
  -- which is equivalent to: {CommandA = '', CommandB = ''} (ie. no opts)
  if config.commands ~= nil and vim.tbl_islist(config.commands) then
    local commands = {}
    for _, command in ipairs(config.commands) do
      commands[command] = true
    end
    config.commands = commands
  end

  local key = '_' .. lazy_index
  lazy_index = lazy_index + 1
  wincent.g.lazy[key] = config

  config.load = function()
    if config.beforeload ~= nil then
      for _, callback in ipairs(config.beforeload) do
        callback()
      end
    end

    if config.commands ~= nil then
      for command in pairs(config.commands) do
        vim.cmd('delcommand ' .. command)
      end
    end

    vim.cmd('packadd ' .. config.pack)

    if config.nnoremap ~= nil then
      for lhs, rhs_and_opts in pairs(config.nnoremap) do
        local rhs = rhs_and_opts[1]
        local opts = rhs_and_opts[2] or {}
        wincent.vim.nnoremap(lhs, rhs, opts)
      end
    end

    if config.afterload ~= nil then
      for _, callback in ipairs(config.afterload) do
        callback()
      end
    end

    wincent.g.lazy[key] = nil
  end

  if config.commands ~= nil then
    for command, opts in pairs(config.commands) do
      if opts == true then
        -- TODO: consider supporting type(opts) == 'table' in future
        -- eg. {nargs = '?', bar = true, bang = true} etc
        opts = ''
      end
      vim.cmd(
        'command! ' .. opts .. ' ' .. command .. ' ' ..
        ':call v:lua.wincent.g.lazy.' ..  key .. '.load() <bar> ' ..
        command .. ' <args>'
      )
    end
  end

  if config.nnoremap ~= nil then
    for lhs, rhs_and_opts in pairs(config.nnoremap) do
      local rhs = rhs_and_opts[1]
      local opts = rhs_and_opts[2] or {}
      wincent.vim.nnoremap(
        lhs,
        ':call v:lua.wincent.g.lazy.' .. key .. '.load()<CR>' ..
        rhs,
        opts
      )
    end
  end
end

return lazy
