-- Provides a lazy autoload mechanism similar to Vimscript's autoload mechanism.
--
-- In Vimscript, we would write:
--
--    :set tabline=wincent#tabline#render()
--
-- and Neovim would look for function named `wincent#tabline#render()` in
-- "autoload/wincent/tabline.vim".
--
-- Using the mechanism implemented here, in Lua, we can write:
--
--    vim.opt.tabline = '%!v:lua.wincent.tabline.render()'
--
-- and Neovim will lazy-load these files in sequence before calling
-- `wincent.tabline.render()`:
--
-- 1. "lua/wincent/tabline.lua" (or "lua/wincent/tabline/init.lua")
-- 2. "lua/wincent/tabline/render.lua" (or "lua/wincent/tabline/render/init.lua")
--
-- Note that this works because:
--
-- - `wincent` is a global (defined in "lua/wincent/init.lua", which is required
--    with `require('wincent')` at the top of "~/.config/nvim/init.lua").
-- - "lua/wincent/init.lua" includes an `autoload('wincent')` call.
-- - "lua/wincent/tabline/init.lua" includes an `autoload('wincent.tabline')`
--    call.
-- - "lua/wincent/tabline/render.lua" returns a function.
--
-- This mechanism should be used in places like the example above, where we have
-- to pass a string containing a Lua expression in a context that expects
-- Vimscript. These places often use `v:lua`. The autoloading mechanism saves us
-- from writing something less pleasant, like:
--
--     vim.opt.tabline = '%{luaeval("require(\'wincent.tabline.render\')()")}'
--
-- It should _not_ be used in pure Lua contexts (ie. places where we can
-- literally write Lua instead of passing Lua snippets around in strings). In
-- pure Lua contexts it is better to use an explicit `require` instead, because
-- this will work nicely with file navigation (eg. `gf`), jumping to definition,
-- and showing hover documentation.
--
local autoload = function(base)
  local storage = {}
  local mt = {
    __index = function(_, key)
      if storage[key] == nil then
        storage[key] = require(base .. '.' .. key)
      end
      return storage[key]
    end,
  }

  return setmetatable({}, mt)
end

return autoload
