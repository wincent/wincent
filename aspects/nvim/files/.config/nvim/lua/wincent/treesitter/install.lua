-- Convenience wrapper around `:TSInstall [lang]` which installs all
-- configured parsers.
--
-- Run with: `:lua require('wincent.treesitter.install')()`
--
-- Pass `{wait = true}` to block until all parsers are installed:
--
--     :lua require('wincent.treesitter.install')({wait = true})
--
local function install(opts)
  opts = opts or {}
  local parsers = require('wincent.treesitter.config').get().parsers
  local task = require('nvim-treesitter').install(parsers)
  if opts.wait then
    task:wait()
  end
end

return install
