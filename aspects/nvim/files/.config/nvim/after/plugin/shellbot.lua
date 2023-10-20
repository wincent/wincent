vim.api.nvim_create_user_command('ChatGPT', function ()
  local has_shellbot, shellbot = pcall(require, 'chatgpt')
  if has_shellbot then
    shellbot.chatgpt()
  else
    vim.api.nvim_err_writeln("error: could not require 'chatgpt'; is the submodule initialized?")
  end
end, {})
