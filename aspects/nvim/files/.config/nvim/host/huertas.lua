-- Host-specific overrides for huertas.

-- Give plug-in a chance to load before setting it up.
vim.defer_fn(function()
  if vim.fn.exists('*clipper#set_invocation') == 1 then
    vim.fn['clipper#set_invocation'](os.getenv('HOME') .. '/.zsh/bin/clip')
  end
end, 0)
