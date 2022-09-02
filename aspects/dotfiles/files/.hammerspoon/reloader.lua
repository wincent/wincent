--
-- Auto-reload config on change.
--

local events = require('events')
local log = require('log')

-- Forward function declarations.
local reload = nil
local reloadFiles = nil

reloadFiles = function(files)
  local shouldReload = false
  for _, file in pairs(files) do
    if file:sub(-4) == '.lua' then
      shouldReload = true
    end
  end
  if shouldReload then
    reload()
  end
end

reload = function()
  events.emit('reload')
  hs.reload()
end

return {
  init = function()
    local watcher = hs.pathwatcher.new(os.getenv('HOME') .. '/.hammerspoon/', reloadFiles)
    watcher:start()
  end,
  reload = reload,
}
