-- vim: ft=lua
-- Ashes theme for Rex
-- Scheme Author: Jannik Siebert (https://github.com/janniks)
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

local name = "base16-ashes"
local variant = "dark"

-- This must match themes/ghostty/base16-ashes exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Ashes theme for Ghostty
# Scheme Author: Jannik Siebert (https://github.com/janniks)
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#1c2023
palette = 1=#c7ae95
palette = 2=#95c7ae
palette = 3=#aec795
palette = 4=#ae95c7
palette = 5=#c795ae
palette = 6=#95aec7
palette = 7=#c7ccd1
palette = 8=#747c84
palette = 9=#c7ae95
palette = 10=#95c7ae
palette = 11=#aec795
palette = 12=#ae95c7
palette = 13=#c795ae
palette = 14=#95aec7
palette = 15=#f3f4f5
palette = 16=#c7c795
palette = 17=#c79595
palette = 18=#393f45
palette = 19=#565e65
palette = 20=#adb3ba
palette = 21=#dfe2e5

# Foreground & background colors
background = #1c2023
foreground = #c7ccd1
cursor-color = #c7ccd1
selection-background = #c7ccd1
selection-foreground = #565e65
search-background = #aec795
search-foreground = #393f45
search-selected-background = #c7c795
search-selected-foreground = #393f45

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #f3f4f5
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #ae95c7
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
