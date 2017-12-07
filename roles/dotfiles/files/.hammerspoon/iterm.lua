--
-- Switches iTerm dynamic profile based on screen changes.
--

local events = require 'events'
local log = require 'log'

-- Forward function declarations.
local switchProfiles = nil

switchProfiles = (function(screenCount)
  -- TODO: make this a template so that I can use variables here instead of
  -- writing all these paths out long-hand.
  if screenCount == 1 then
    log.i('Configuring iTerm for Retina (internal) display')
    hs.execute("ln -sf \"$HOME/Library/Application Support/iTerm2/Sources/40-Mutt-Retina.json\" \"$HOME/Library/Application Support/iTerm2/DynamicProfiles/Mutt.json\"")
    hs.execute("ln -sf \"$HOME/Library/Application Support/iTerm2/Sources/10-Retina.json\" \"$HOME/Library/Application Support/iTerm2/DynamicProfiles/Wincent.json\"")
  else
    log.i('Configuring iTerm for 4K (external) display')
    hs.execute("ln -sf \"$HOME/Library/Application Support/iTerm2/Sources/40-Mutt-4K.json\" \"$HOME/Library/Application Support/iTerm2/DynamicProfiles/Mutt.json\"")
    hs.execute("ln -sf \"$HOME/Library/Application Support/iTerm2/Sources/10-4K.json\" \"$HOME/Library/Application Support/iTerm2/DynamicProfiles/Wincent.json\"")
  end
end)

return {
  init = (function()
    events.subscribe('layout', switchProfiles)
  end),
}
