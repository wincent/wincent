--- @type table<string, boolean>
local done = {}

--- @class OnceOptions
--- @field key string

--- Convenience helper for running `callback` identified by `key` no more than
--- once.
---
--- @param callback function
--- @param options OnceOptions
local function once(callback, options)
  if not done[options.key] then
    done[options.key] = true
    callback()
  end
end

return once
