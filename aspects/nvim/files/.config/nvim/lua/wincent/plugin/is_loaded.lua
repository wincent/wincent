-- Checks to see whether `plugin` is in the `'runtimepath'` ie. whether the call
-- to `wincent.plugin.load()` (and therefore `:packadd`) is present and
-- uncommented in the `init.lua` startup file.
--
-- For Lua plugins, we would generally do the idiomatic thing with `pcall()`
-- instead:
--
--    local has_cmp, cmp = pcall(require, 'cmp')
--    if has_cmp then
--      -- Use `cmp` here...
--    end
--
-- But for Vimscript plugins, `pcall()` is of no use, so we have this function
-- instead.
--
local is_loaded = function(plugin)
  for _, candidate in ipairs(vim.opt.runtimepath:get()) do
    if plugin == candidate:sub(-#plugin) then
      return true
    end
  end
  return false
end

return is_loaded
