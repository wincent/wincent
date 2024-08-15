vim.api.nvim_create_user_command('ChatGPT', function()
  local has_shellbot, shellbot = pcall(require, 'chatbot')
  if not has_shellbot then
    vim.api.nvim_err_writeln("error: could not require 'chatbot'; is the shellbot submodule initialized?")
    return
  end
  local env = vim.env['SHELLBOT']
  if env ~= nil then
    local executable = vim.fn.split(env, ' ')[1]
    if executable ~= nil and vim.fn.executable(executable) == 1 then
      shellbot.chatbot()
      return
    end
  end
  vim.api.nvim_err_writeln('error: SHELLBOT does not appear to be executable')
end, {})

-- Set up an autocmd to stop me from accidentally quitting vim when shellbot is
-- the only thing running in it. I do this all the time, losing valuable state.
vim.api.nvim_create_autocmd('QuitPre', {
  pattern = '*',
  callback = function ()
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
