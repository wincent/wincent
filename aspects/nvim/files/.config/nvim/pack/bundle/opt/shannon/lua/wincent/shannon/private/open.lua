return function(path, line)
  vim.cmd.edit(path)
  if line then
    vim.api.nvim_win_set_cursor(0, { line, 0 })
  end
end
