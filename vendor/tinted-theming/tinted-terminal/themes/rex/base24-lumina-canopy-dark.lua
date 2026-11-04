-- vim: ft=lua
-- Lumina Canopy Dark theme for Rex
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

local name = "base24-lumina-canopy-dark"
local variant = "dark"

-- This must match themes/ghostty/base24-lumina-canopy-dark exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Lumina Canopy Dark theme for Ghostty
# Scheme Author: Razik Ikhlef (https://github.com/RazikSF)
# Scheme System: base24
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#0c1b10
palette = 1=#d57068
palette = 2=#99d0a4
palette = 3=#d1cca8
palette = 4=#9acaf1
palette = 5=#bfb8f3
palette = 6=#86cfd7
palette = 7=#d8e3d6
palette = 8=#223427
palette = 9=#e1928b
palette = 10=#b2ebbd
palette = 11=#f4e792
palette = 12=#c0e3ff
palette = 13=#fdc5f8
palette = 14=#9fe9f1
palette = 15=#d8e3d6
palette = 16=#f6ae7c
palette = 17=#e2acdd
palette = 18=#0f2014
palette = 19=#192a1d
palette = 20=#5b6f5f
palette = 21=#a8b5aa

# Foreground & background colors
background = #0c1b10
foreground = #d8e3d6
cursor-color = #d8e3d6
selection-background = #d8e3d6
selection-foreground = #192a1d
search-background = #d1cca8
search-foreground = #0f2014
search-selected-background = #f6ae7c
search-selected-foreground = #0f2014

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #d8e3d6
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #c0e3ff
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
