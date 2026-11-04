-- vim: ft=lua
-- Nova theme for Rex
-- Scheme Author: George Essig (https://github.com/gessig), Trevor D. Miller (https://trevordmiller.com)
-- Scheme System: base16
-- Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)
--
-- Imports this scheme into every Rex app running on this machine and switches
-- the app to the scheme's appearance. Run it with the Rex CLI, for example as a
-- tinty hook:
--
--     hook = "rex --autostart=false do %f"
--
-- Rex can only import theme files from the app's own machine, so apps connected
-- to the Rex server from another machine are skipped. Run tinty there too.

local name = "base16-nova"
local variant = "dark"

-- This must match themes/ghostty/base16-nova exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Nova theme for Ghostty
# Scheme Author: George Essig (https://github.com/gessig), Trevor D. Miller (https://trevordmiller.com)
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#3c4c55
palette = 1=#83afe5
palette = 2=#7fc1ca
palette = 3=#a8ce93
palette = 4=#83afe5
palette = 5=#9a93e1
palette = 6=#f2c38f
palette = 7=#c5d4dd
palette = 8=#899ba6
palette = 9=#83afe5
palette = 10=#7fc1ca
palette = 11=#a8ce93
palette = 12=#83afe5
palette = 13=#9a93e1
palette = 14=#f2c38f
palette = 15=#556873
palette = 16=#7fc1ca
palette = 17=#f2c38f
palette = 18=#556873
palette = 19=#6a7d89
palette = 20=#899ba6
palette = 21=#899ba6

# Foreground & background colors
background = #3c4c55
foreground = #c5d4dd
cursor-color = #c5d4dd
selection-background = #c5d4dd
selection-foreground = #6a7d89
search-background = #a8ce93
search-foreground = #556873
search-selected-background = #7fc1ca
search-selected-foreground = #556873

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #556873
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #83afe5
]==]

local me = assert(rex.call("server.whoami")).principal
if me.transport ~= "unix" then
    io.stderr:write("rex: not connected to a local Rex server, skipping\n")
    return
end

-- Rex names an imported theme after its file, and re-importing a name
-- replaces that theme's colors.
local home = os.getenv("HOME")
local dir = (os.getenv("XDG_CACHE_HOME") or (home .. "/.cache")) .. "/tinted-theming/rex"
rex.exec({ "mkdir", "-p", dir })
local file = dir .. "/" .. name
local out = assert(io.open(file, "w"))
out:write(theme)
out:close()

local function perform(client, action, args)
    local _, err = rex.call("client.perform", {
        client_id = client.client_id, action = action, args = args,
    })
    return err
end

-- Apps connected over the server's local socket as the same user are the
-- apps on this machine.
local list = assert(rex.call("client.list", { kinds = { "app" } }))
local failures = {}
for _, client in ipairs(list.clients or {}) do
    local peer = client.principal or {}
    local label = (client.info or {}).label or client.client_id
    if peer.transport == "unix" and peer.uid == me.uid then
        -- Rex guesses a theme's appearance from its colors when importing.
        -- Switch to the scheme's own variant in case it guessed wrong.
        local err = perform(client, "client.theme.import", { path = file })
            or perform(client, "client.appearance.switch_mode", { mode = variant })
        if err then
            table.insert(failures, label .. ": " .. tostring(err))
        end
    else
        io.stderr:write("rex: skipped " .. label .. ", which is connected from another machine or user\n")
    end
end

if #failures > 0 then
    error(table.concat(failures, "\n"))
end
