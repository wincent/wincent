-- Convenience wrapper around `:TSInstall [lang]` which installs all
-- configured parsers.
--
-- Run with: `:lua require('wincent.treesitter.install')()`
--
local function install()
  local parsers = require('wincent.treesitter.config').get().parsers
  for _, parser in parsers do
    require('nvim-treesitter').install(parser)
  end
end

return install
