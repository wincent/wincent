--
-- Attempted workaround for:
-- https://github.com/tekezo/Karabiner-Elements/issues/1645
--

local log = require 'log'

local trim = (function(s)
  return s:gsub("(.-)%s*$", "%1")
end)

local uid = trim(hs.execute('id -u'))

local disable = (function()
  log.i('Disabling Karabiner')
  hs.execute('launchctl bootout gui/' .. uid .. ' /Library/LaunchAgents/org.pqrs.karabiner.karabiner_console_user_server.plist')
  hs.execute('launchctl disable gui/' .. uid .. '/org.pqrs.karabiner.karabiner_console_user_server')
end)

local enable = (function()
  log.i('Enabling Karabiner')
  hs.execute('launchctl enable gui/' .. uid .. '/org.pqrs.karabiner.karabiner_console_user_server')
  hs.execute('launchctl bootstrap gui/' .. uid .. ' /Library/LaunchAgents/org.pqrs.karabiner.karabiner_console_user_server.plist')
  hs.execute('launchctl enable gui/' .. uid .. '/org.pqrs.karabiner.karabiner_console_user_server')
end)

return {
  init = (function()
    local watcher = hs.caffeinate.watcher.new(
      function(event)
        if event == hs.caffeinate.watcher.systemWillSleep then
          disable()
        elseif event == hs.caffeinate.watcher.screensDidUnlock then
          enable()
        end
      end
    )
    watcher:start()
  end),
}
