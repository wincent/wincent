--
-- Simple global event pub-sub hub.
--

local registry = {}

return {
  emit = (function(eventName, ...)
    local callbacks = registry[eventName]
    if callbacks == nil then
      return
    end
    for _, callback in ipairs(callbacks) do
      callback(...)
    end
  end),

  subscribe = (function(eventName, callback)
    local callbacks = registry[eventName]
    if callbacks == nil then
      callbacks = {}
      registry[eventName] = callbacks
    end
    callbacks[#callbacks + 1] = callback
  end),
}
