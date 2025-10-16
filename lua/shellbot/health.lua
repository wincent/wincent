local health = vim.health -- after: https://github.com/neovim/neovim/pull/18720
  or require('health') -- before: v0.8.x

return {
  -- Run with `:checkhealth shellbot`
  check = function()
    local shellbot = vim.env['SHELLBOT']
    if shellbot == nil then
      health.warn('SHELLBOT environment variable is not set')
    else
      local executable = vim.fn.split(shellbot, ' ')[1]
      if executable == nil then
        health.warn('SHELLBOT environment variable is empty')
      elseif vim.fn.executable(executable) ~= 1 then
        health.warn('SHELLBOT (' .. vim.inspect(shellbot) .. ') is not executable')
      else
        health.ok('SHELLBOT environment variable is set to an executable')
      end
    end
  end,
}
