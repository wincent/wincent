--
-- Attempted workaround for:
-- https://github.com/tekezo/Karabiner-Elements/issues/1645
--
-- In the event that the machine goes to sleep before this can finishing
-- running, Karabiner-Elements may still be running at the lock
-- screen. In that case, hit Right Shift three times and say "there's no
-- place like home", which Karabiner-Elements will take as a cue to disable
-- itself.

local log = require 'log'

local disable = (function()
  log.i('Disabling Karabiner')
  hs.execute('~/.zsh/bin/karabiner-kill')
end)

local enable = (function()
  log.i('Enabling Karabiner')
  hs.execute('~/.zsh/bin/karabiner-boot')
end)

return {
  init = (function()
    local watcher = hs.caffeinate.watcher.new(
      function(event)
        if event == hs.caffeinate.watcher.screensDidLock then
          disable()
        elseif event == hs.caffeinate.watcher.screensDidUnlock then
          enable()
        end
      end
    )
    watcher:start()
  end),
}
