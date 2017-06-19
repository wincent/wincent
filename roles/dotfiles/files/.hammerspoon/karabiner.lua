--
-- Until Karabiner-Elements gets the ability to target specific devices, this
-- module does auto-switching of profiles based on what's plugged in.
--

local events = require 'events'
local log = require 'log'

local handleScreenEvent = nil
local reload = nil
local updateKarabinerProfile = nil
local watcher = nil

local screenCount = #hs.screen.allScreens()

handleScreenEvent = (function()
  local screens = hs.screen.allScreens()
  if not (#screens == screenCount) then
    screenCount = #screens
    updateKarabinerProfile()
  end
end)

reload = (function()
  watcher:stop()
  watcher = nil
end)

updateKarabinerProfile = (function()
  log.i('checking updating profile')
end)

events.subscribe('reload', reload)

return {
  init = (function()
    watcher = hs.screen.watcher.new(handleScreenEvent)
    watcher:start()
  end),
}
