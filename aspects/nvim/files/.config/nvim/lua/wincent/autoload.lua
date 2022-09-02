-- Provides a lazy autoload mechanism similar to Vimscript's autoload mechanism.
--
-- Examples:
--
--    " Vimscript - looks for function named `wincent#foo#bar#baz()` in
--    " autoload/wincent/foo/bar.vim):
--
--    call wincent#foo#bar#baz()
--
--    -- Lua - lazy-loads these files in sequence before calling
--    -- `wincent.foo.bar.baz()`:
--    --
--    --    1. lua/wincent/foo.lua (or lua/wincent/foo/init.lua)
--    --    2. lua/wincent/foo/bar.lua (or lua/wincent/foo/bar/init.lua)
--    --    3. lua/wincent/foo/bar/baz.lua (or lua/wincent/foo/bar/baz/init.lua)
--
--    local wincent = require'wincent'
--    wincent.foo.bar.baz()
--
--    -- Note that because `require'wincent'` appears at the top of the top-level
--    -- init.lua, the previous example can be written as:
--
--    wincent.foo.bar.baz()
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
