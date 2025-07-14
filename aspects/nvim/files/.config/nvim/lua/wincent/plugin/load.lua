--- @param ... string The names of the plugins to be loaded
--- @return nil
local function load(...)
  local plugins = { ... }

  -- If already booted, use `:packadd` (modifies 'runtimepath' _and_ sources
  -- files). Otherwise, use `:packadd!` (just modifies 'runtimepath'; Neovim
  -- will source the files later as part of |load-plugins| process).
  local bang = vim.v.vim_did_enter ~= 1
  for _, plugin in ipairs(plugins) do
    vim.cmd.packadd({ plugin, bang = bang })
  end
end

return load
