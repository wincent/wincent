-- vim: ft=lua
-- Mission Brogue theme for Rex
-- Scheme Author: Thomas Leon Highbaugh
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

local name = "base24-mission-brogue"
local variant = "dark"

-- This must match themes/ghostty/base24-mission-brogue exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Mission Brogue theme for Ghostty
# Scheme Author: Thomas Leon Highbaugh
# Scheme System: base24
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#283139
palette = 1=#efa9a9
palette = 2=#8cd4b0
palette = 3=#e0b88a
palette = 4=#a2c5fd
palette = 5=#ccb7db
palette = 6=#93dfec
palette = 7=#93a5b4
palette = 8=#60778a
palette = 9=#f6bfbf
palette = 10=#b5e090
palette = 11=#fff0b2
palette = 12=#c3d9fd
palette = 13=#e3c3e6
palette = 14=#b2f0fd
palette = 15=#e7ebee
palette = 16=#f2db78
palette = 17=#8e9ecb
palette = 18=#3b4954
palette = 19=#4d606f
palette = 20=#788ea1
palette = 21=#abb9c4

# Foreground & background colors
background = #283139
foreground = #93a5b4
cursor-color = #93a5b4
selection-background = #93a5b4
selection-foreground = #4d606f
search-background = #e0b88a
search-foreground = #3b4954
search-selected-background = #f2db78
search-selected-foreground = #3b4954

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #e7ebee
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #c3d9fd
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
