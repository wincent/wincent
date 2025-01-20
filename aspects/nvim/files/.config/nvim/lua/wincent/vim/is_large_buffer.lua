local is_large_buffer = function(buffer)
  buffer = buffer or 0
  if type(vim.b.is_large_buffer) == 'nil' then
    -- Based on check shown here: https://github.com/nvim-treesitter/nvim-treesitter
    local max_filesize = 1024 * 1024 -- 1MB
    local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buffer))
    vim.b.is_large_buffer = ok and stats and stats.size > max_filesize
  end
  return vim.b.is_large_buffer
end

return is_large_buffer
