return function()
  local ns = vim.api.nvim_create_namespace('shannon')
  vim.api.nvim_buf_clear_namespace(0, ns, 0, -1)
end
