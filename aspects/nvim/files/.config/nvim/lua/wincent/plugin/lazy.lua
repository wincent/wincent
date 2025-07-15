local store = {}

local lazy_index = 0

local function lazy(pack, config)
  config = vim.deepcopy(config or {})

  -- As a convenience, accept: {'CommandA', 'CommandB'}
  -- and transform it into: {CommandA = true, CommandB = true}
  -- which is equivalent to: {CommandA = '', CommandB = ''} (ie. no opts)
  if config.commands ~= nil and vim.islist(config.commands) then
    local commands = {}
    for _, command in ipairs(config.commands) do
      commands[command] = true
    end
    config.commands = commands
  end

  local key = '_' .. lazy_index
  lazy_index = lazy_index + 1
  store[key] = config

  config.load = function()
    if config.beforeload ~= nil then
      config.beforeload()
    end

    if config.commands ~= nil then
      for command in pairs(config.commands) do
        vim.cmd.delcommand(command)
      end
    end

    vim.cmd.packadd(pack)

    if config.keymap ~= nil then
      for _, item in ipairs(config.keymap) do
        local modes = item[1]
        local lhs = item[2]
        local cmd = item[3]
        local opts = item[4] or {}
        local rhs = function()
          vim.cmd(cmd)
        end
        vim.keymap.set(modes, lhs, rhs, opts)
      end
    end

    if config.afterload ~= nil then
      config.afterload()
    end

    store[key] = nil
  end

  if config.commands ~= nil then
    for command, opts in pairs(config.commands) do
      if opts == true then
        opts = {}
      end
      vim.api.nvim_create_user_command(command, function(data)
        store[key].load()
        if data.args ~= '' then
          vim.cmd({ cmd = command, args = { data.args } })
        else
          vim.cmd(command)
        end
      end, opts)
    end
  end

  if config.keymap ~= nil then
    for _, item in ipairs(config.keymap) do
      local modes = item[1]
      local lhs = item[2]
      local cmd = item[3]
      local opts = item[4] or {}
      local rhs = function()
        store[key].load()
        vim.cmd(cmd)
      end
      vim.keymap.set(modes, lhs, rhs, opts)
    end
  end

  if config.commands == nil and config.keymap == nil then
    -- No triggers defined, so just load this thing after startup.
    vim.defer_fn(config.load, 0)
  else
    -- `packadd!` adds directories to 'runtimepath', so things like `:help`
    -- will work, but Vim won't load the plugin files as long as we do this
    -- _after_ startup.
    if vim.v.vim_did_enter == 1 then
      vim.cmd.packadd({ pack, bang = true })
    else
      require('wincent.nvim.autocmd')('VimEnter', '*', function()
        vim.cmd.packadd({ pack, bang = true })
      end, { once = true })
    end
  end
end

return lazy
