-- Note: This config is shared by both filetype=javascriptreact +
-- filetype=typescriptreact (via a symlink).

-- Work around filetype that landed in upstream Vim here:
-- https://github.com/vim/vim/issues/4830
vim.cmd(
  'noautocmd set filetype=' ..
  vim.api.nvim_buf_get_option(0, 'filetype'):gsub('javascriptreact', 'javascript')
)
