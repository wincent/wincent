-- vim: ft=lua
-- Lumina Parchment Dark theme for Rex
-- Scheme Author: Razik Ikhlef (https://github.com/RazikSF)
-- Scheme System: base24
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

local name = "base24-lumina-parchment-dark"
local variant = "dark"

-- This must match themes/ghostty/base24-lumina-parchment-dark exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Lumina Parchment Dark theme for Ghostty
# Scheme Author: Razik Ikhlef (https://github.com/RazikSF)
# Scheme System: base24
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#2a2116
palette = 1=#d47169
palette = 2=#92d3b9
palette = 3=#e0ba6a
palette = 4=#97bdf4
palette = 5=#bcb5ee
palette = 6=#85cbd3
palette = 7=#efe5d0
palette = 8=#443a2d
palette = 9=#e1938b
palette = 10=#aaeed2
palette = 11=#fad484
palette = 12=#bbd7ff
palette = 13=#ecbef3
palette = 14=#9ee5ee
palette = 15=#efe5d0
palette = 16=#ffbd90
palette = 17=#d4a3dc
palette = 18=#302619
palette = 19=#3a3023
palette = 20=#7f7162
palette = 21=#b8b0a6

# Foreground & background colors
background = #2a2116
foreground = #efe5d0
cursor-color = #efe5d0
selection-background = #efe5d0
selection-foreground = #3a3023
search-background = #e0ba6a
search-foreground = #302619
search-selected-background = #ffbd90
search-selected-foreground = #302619

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #efe5d0
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #bbd7ff
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
