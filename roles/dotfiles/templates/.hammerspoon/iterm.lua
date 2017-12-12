-- {{ ansible_managed }}

--
-- Switches iTerm dynamic profile based on screen changes.
--

local events = require 'events'
local log = require 'log'

-- Forward function declarations.
local switchProfiles = nil

switchProfiles = (function(screenCount)
  if screenCount == 1 then
    log.i('Configuring iTerm for Retina (internal) display')
{% for entry in iterm_dynamic_profiles.retina %}
    hs.execute("ln -sf \"$HOME/Library/Application Support/iTerm2/Sources/{{ entry.src }}\" \"$HOME/Library/Application Support/iTerm2/DynamicProfiles/{{ entry.dest }}\"")
{% endfor %}
  else
    log.i('Configuring iTerm for 4K (external) display')
{% for entry in iterm_dynamic_profiles.external %}
    hs.execute("ln -sf \"$HOME/Library/Application Support/iTerm2/Sources/{{ entry.src }}\" \"$HOME/Library/Application Support/iTerm2/DynamicProfiles/{{ entry.dest }}\"")
{% endfor %}
  end
end)

return {
  init = (function()
    events.subscribe('layout', switchProfiles)
  end),
}
