vim.api.nvim_create_user_command('ChatGPT', function()
  local has_shellbot, shellbot = pcall(require, 'chatgpt')
  if not has_shellbot then
    vim.api.nvim_err_writeln("error: could not require 'chatgpt'; is the submodule initialized?")
    return
  end
  if vim.env['SHELLBOT'] == nil or vim.fn.executable(vim.env['SHELLBOT']) ~= 1 then
    vim.api.nvim_err_writeln('error: SHELLBOT does not appear to be executable')
    return
  end
  shellbot.chatgpt()
end, {})
