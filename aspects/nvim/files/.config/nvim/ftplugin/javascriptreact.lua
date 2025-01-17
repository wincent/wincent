-- Note: This config is shared by both filetype=javascriptreact +
-- filetype=typescriptreact (via a symlink).

-- Work around filetype that landed in upstream Vim here:
-- https://github.com/vim/vim/issues/4830
vim.cmd(
  'noautocmd set filetype='
    .. vim.bo.filetype:gsub('javascriptreact', 'javascript'):gsub('typescriptreact', 'typescript')
)
