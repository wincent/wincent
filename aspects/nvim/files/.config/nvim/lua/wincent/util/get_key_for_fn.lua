-- Used as tie-breaker in the event that multiple registrations happen for same
-- file + line.
local callback_index = 0

local config_prefix = vim.env.HOME .. '/.config/nvim/'

-- Derives a "safe" key for the given function `fn` such that it can be stored
-- in `storage` table and used in Lua expressions (eg. `storage.key_name`).
--
-- Keys are produced by:
--
--    - Getting the path to the function (via `debug.getinfo`).
--    - Stripping off the common prefix (ie. "~/.config/nvim/").
--    - Dropping the file extension (ie. ".lua").
--    - Replacing non-alphanumeric characters (slashes, basically) with "_".
--    - Appending the line-number.
--    - Disambiguating colliding keys with a monotonically increasing
--      tie-breaker value.
--
-- For example, an anonymous function defined in "~/.config/nvim/plugin/mappings/normal.lua"
-- might receive a key like `plugin_mappings_normal_L38`.
--
local get_key_for_fn = function(fn, storage)
  local info = debug.getinfo(fn)
  local key = info.short_src
  if vim.startswith(key, config_prefix) then
    key = key:sub(#config_prefix + 1)
  end
  if vim.endswith(key, '.lua') then -- and sure would be weird if it _didn't_
    key = key:sub(1, #key - 4)
  end
  key = key:gsub('%W', '_')
  key = key .. '_L' .. info.linedefined
  if storage[key] ~= nil then
    key = key .. '_' .. callback_index
    callback_index = callback_index + 1
  end
  return key
end

return get_key_for_fn
