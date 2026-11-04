-- vim: ft=lua
-- Lumina Nebula Dark theme for Rex
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

local name = "base24-lumina-nebula-dark"
local variant = "dark"

-- This must match themes/ghostty/base24-lumina-nebula-dark exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Lumina Nebula Dark theme for Ghostty
# Scheme Author: Razik Ikhlef (https://github.com/RazikSF)
# Scheme System: base24
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#161826
palette = 1=#d57068
palette = 2=#8fdcba
palette = 3=#f3c085
palette = 4=#c6d6e8
palette = 5=#b0a4f8
palette = 6=#88d2da
palette = 7=#dde1ec
palette = 8=#2d3041
palette = 9=#e2928a
palette = 10=#b0f5d5
palette = 11=#ffdfba
palette = 12=#d8eaff
palette = 13=#ffc8f9
palette = 14=#a1ecf5
palette = 15=#dde1ec
palette = 16=#fab17e
palette = 17=#e5aedf
palette = 18=#1a1c2c
palette = 19=#242636
palette = 20=#666b7e
palette = 21=#aeb0be

# Foreground & background colors
background = #161826
foreground = #dde1ec
cursor-color = #dde1ec
selection-background = #dde1ec
selection-foreground = #242636
search-background = #f3c085
search-foreground = #1a1c2c
search-selected-background = #fab17e
search-selected-foreground = #1a1c2c

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #dde1ec
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #d8eaff
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
