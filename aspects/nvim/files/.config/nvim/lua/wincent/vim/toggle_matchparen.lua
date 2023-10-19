local toggle_matchparen = function()
  -- Preserve current window because {Do,No}MatchParen cycle with :windo.
  local window = vim.api.nvim_get_current_win()
  if vim.g.loaded_matchparen then
    vim.cmd('NoMatchParen')
  else
    vim.cmd('DoMatchParen')
  end
  vim.api.nvim_set_current_win(window)
end

return toggle_matchparen
