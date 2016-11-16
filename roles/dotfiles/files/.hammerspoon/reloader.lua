--
-- Auto-reload config on change.
--

local events = require 'events'
local log = require 'log'

local function reloadConfig(files)
  local reload = false
  for _, file in pairs(files) do
    if file:sub(-4) == '.lua' then
      reload = true
    end
  end
  if reload then
    events.emit('reload')
    hs.reload()
  end
end

return {
  init = (function()
    local watcher = hs.pathwatcher.new(
      os.getenv('HOME') .. '/.hammerspoon/',
      reloadConfig
    )
    watcher:start()
  end)
}
