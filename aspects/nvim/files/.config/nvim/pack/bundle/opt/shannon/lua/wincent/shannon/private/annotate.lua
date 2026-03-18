return function(line, text, highlight)
  local ns = vim.api.nvim_create_namespace('shannon')
  vim.api.nvim_buf_set_extmark(0, ns, line - 1, 0, {
    virt_lines = { { { text, highlight or 'DiagnosticInfo' } } },
  })
end
