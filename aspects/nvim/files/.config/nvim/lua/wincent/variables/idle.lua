local idle = function()
  -- Set up shortcut variables for "hash -d" directories.
  local dirs = vim.fn.system([[zsh -c "source ~/.zsh/hash; hash -d"]])

  local lines = vim.split(dirs, '\n')
  for _, line in pairs(lines) do
    local pair = vim.split(line, '=')
    if #pair == 2 then
      local var = pair[1]
      local dir = pair[2]

      -- Make sure we don't clobber any pre-existing variables.
      if vim.fn.exists('$' .. var) == 0 then
        vim.cmd('let $' .. var .. '="' .. dir .. '"')
      end
    end
  end
end

return idle
