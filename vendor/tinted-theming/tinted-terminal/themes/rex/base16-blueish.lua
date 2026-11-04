-- vim: ft=lua
-- Blueish theme for Rex
-- Scheme Author: Ben Mayoras
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

local name = "base16-blueish"
local variant = "dark"

-- This must match themes/ghostty/base16-blueish exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Blueish theme for Ghostty
# Scheme Author: Ben Mayoras
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#182430
palette = 1=#4ce587
palette = 2=#c3e88d
palette = 3=#f6cd5c
palette = 4=#82aaff
palette = 5=#ff84dd
palette = 6=#5fd1ff
palette = 7=#c8e1f8
palette = 8=#616d78
palette = 9=#4ce587
palette = 10=#c3e88d
palette = 11=#f6cd5c
palette = 12=#82aaff
palette = 13=#ff84dd
palette = 14=#5fd1ff
palette = 15=#8f98a0
palette = 16=#f6a85c
palette = 17=#bbd2e8
palette = 18=#243c54
palette = 19=#46290a
palette = 20=#74afe7
palette = 21=#ddeaf6

# Foreground & background colors
background = #182430
foreground = #c8e1f8
cursor-color = #c8e1f8
selection-background = #c8e1f8
selection-foreground = #46290a
search-background = #f6cd5c
search-foreground = #243c54
search-selected-background = #f6a85c
search-selected-foreground = #243c54

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #8f98a0
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #82aaff
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
