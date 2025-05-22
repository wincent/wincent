local has_shellbot, shellbot = pcall(require, 'chatbot')
if has_shellbot then
  -- Set up wrapper commands for specifically targetting ChatGPT, Claude (etc).
  local function get_executable()
    local executable = vim.fn.split((vim.env['SHELLBOT'] or '/dev/null'), ' ')[1]
    if executable and vim.fn.executable(executable) == 1 then
      return executable
    else
      vim.api.nvim_echo(
        { {
          'error: $SHELLBOT does not appear to be executable',
          'ErrorMsg',
        } },
        true,
        {}
      )
    end
  end

  vim.api.nvim_create_user_command('ChatGPT', function()
    local executable = get_executable()
    if executable then
      shellbot.chatbot({
        OPENAI_API_KEY = vim.env.OPENAI_API_KEY,
      })
    end
  end, {})

  vim.api.nvim_create_user_command('ChatGPTX', function()
    local executable = get_executable()
    if executable then
      shellbot.chatbot({
        OPENAI_API_KEY = vim.env.OPENAI_API_KEY,
        OPENAI_MODEL = 'o1-mini',
      })
    end
  end, {})

  vim.api.nvim_create_user_command('Claude', function()
    local executable = get_executable()
    if executable then
      shellbot.chatbot({
        ANTHROPIC_API_KEY = vim.env.ANTHROPIC_API_KEY,
      })
    end
  end, {})

  vim.api.nvim_create_user_command('Opus', function()
    local executable = get_executable()
    if executable then
      shellbot.chatbot({
        ANTHROPIC_API_KEY = vim.env.ANTHROPIC_API_KEY,
        ANTHROPIC_MODEL = 'claude-opus-4-20250514',
      })
    end
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
        vim.notify(
          '\n'
            .. '┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓\n'
            .. '┃ Use :q! if you really want to quit the last shellbot window ┃\n'
            .. '┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛\n'
            .. '\n',
          vim.log.levels.WARN
        )

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
    vim.notify('error: SHELLBOT does not appear to be executable', vim.log.levels.ERROR)
  end
  wincent.vim.command('ChatGPT', print_error, {})
  wincent.vim.command('ChatGPTX', print_error, {})
  wincent.vim.command('Claude', print_error, {})
  wincent.vim.command('Opus', print_error, {})
end
