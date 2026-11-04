-- vim: ft=lua
-- Flat theme for Rex
-- Scheme Author: Chris Kempson (http://chriskempson.com)
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

local name = "base16-flat"
local variant = "dark"

-- This must match themes/ghostty/base16-flat exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Flat theme for Ghostty
# Scheme Author: Chris Kempson (http://chriskempson.com)
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#2c3e50
palette = 1=#e74c3c
palette = 2=#2ecc71
palette = 3=#f1c40f
palette = 4=#3498db
palette = 5=#9b59b6
palette = 6=#1abc9c
palette = 7=#e0e0e0
palette = 8=#95a5a6
palette = 9=#e74c3c
palette = 10=#2ecc71
palette = 11=#f1c40f
palette = 12=#3498db
palette = 13=#9b59b6
palette = 14=#1abc9c
palette = 15=#ecf0f1
palette = 16=#e67e22
palette = 17=#be643c
palette = 18=#34495e
palette = 19=#7f8c8d
palette = 20=#bdc3c7
palette = 21=#f5f5f5

# Foreground & background colors
background = #2c3e50
foreground = #e0e0e0
cursor-color = #e0e0e0
selection-background = #e0e0e0
selection-foreground = #7f8c8d
search-background = #f1c40f
search-foreground = #34495e
search-selected-background = #e67e22
search-selected-foreground = #34495e

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #ecf0f1
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #3498db
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
