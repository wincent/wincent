--
-- Attempted workaround for:
-- https://github.com/tekezo/Karabiner-Elements/issues/1645
--

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
