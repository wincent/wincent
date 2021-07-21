local load = function(plugin)
  if vim.v.vim_did_enter == 1 then
    -- Modifies 'runtimepath' _and_ sources files.
    vim.cmd('packadd ' .. plugin)
  else
    -- Just modifies 'runtimepath'; Vim will source the files later as part of
    -- |load-plugins| process.
    vim.cmd('packadd! ' .. plugin)
  end
end

return load
