vim.api.nvim_create_user_command('Shellbot', function()
  local shellbot = require('chatbot')
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
