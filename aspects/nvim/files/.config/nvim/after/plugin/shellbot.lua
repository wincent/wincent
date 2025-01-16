local has_shellbot = pcall(require, 'chatbot')
if has_shellbot then
  -- Set up wrapper commands for specifically targetting ChatGPT and Claude.
  local shellbot = function(config)
    local saved_variables = {}
    for _, unset in ipairs(config.unset or {}) do
      saved_variables[unset] = vim.env[unset]
      vim.env[unset] = nil
    end
    for key, value in pairs(config.set or {}) do
      saved_variables[key] = vim.env[key]
      vim.env[key] = value
    end
    pcall(function()
      vim.cmd('Shellbot')
    end)
    for key, value in pairs(saved_variables) do
      vim.env[key] = value
    end
  end

  wincent.vim.command('ChatGPT', function()
    shellbot({
      unset = { 'ANTHROPIC_API_KEY' },
    })
  end, {})

  wincent.vim.command('ChatGPTX', function()
    shellbot({
      unset = { 'ANTHROPIC_API_KEY' },
      set = {
        OPENAI_MODEL = 'o1-mini',
      },
    })
  end, {})

  wincent.vim.command('Claude', function()
    shellbot({
      unset = { 'OPENAI_API_KEY' },
    })
  end, {})

  wincent.vim.command('Opus', function()
    shellbot({
      unset = { 'OPENAI_API_KEY' },
      set = {
        ANTHROPIC_MODEL = 'claude-3-opus-20240229',
      },
    })
  end, {})

  -- Set up an autocmd to stop me from accidentally quitting vim when shellbot is
  -- the only thing running in it. I do this all the time, losing valuable state.
  vim.api.nvim_create_autocmd('QuitPre', {
    pattern = '*',
    callback = function()
      local buftype = vim.bo.buftype
      local filetype = vim.bo.filetype
      local win_count = #vim.api.nvim_tabpage_list_wins(0)

      if filetype == 'shellbot' and buftype == 'nofile' and win_count == 1 then
        vim.api.nvim_err_writeln('')
        vim.api.nvim_err_writeln('Use :q! if you really want to quit the last shellbot window')
        vim.api.nvim_err_writeln('')

        -- Will make Neovim abort the quit with:
        --
        --    E37: No write since last change
        --    E162: No write since last change for buffer "[No Name]"
        --
        vim.bo.buftype = ''
      end
    end,
  })
else
  local print_error = function()
    vim.api.nvim_err_writeln('error: SHELLBOT does not appear to be executable')
  end
  wincent.vim.command('ChatGPT', print_error, {})
  wincent.vim.command('ChatGPTX', print_error, {})
  wincent.vim.command('Claude', print_error, {})
  wincent.vim.command('Opus', print_error, {})
end
