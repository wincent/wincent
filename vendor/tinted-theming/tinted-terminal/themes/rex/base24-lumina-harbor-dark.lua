-- vim: ft=lua
-- Lumina Harbor Dark theme for Rex
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

local name = "base24-lumina-harbor-dark"
local variant = "dark"

-- This must match themes/ghostty/base24-lumina-harbor-dark exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Lumina Harbor Dark theme for Ghostty
# Scheme Author: Razik Ikhlef (https://github.com/RazikSF)
# Scheme System: base24
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#0d111d
palette = 1=#d0756c
palette = 2=#9bd8b4
palette = 3=#eace8c
palette = 4=#91c5ea
palette = 5=#c1bbef
palette = 6=#91cfd6
palette = 7=#dde1eb
palette = 8=#232837
palette = 9=#de968e
palette = 10=#b9f1d0
palette = 11=#ffe5a9
palette = 12=#b1deff
palette = 13=#ebc4f5
palette = 14=#aae9f0
palette = 15=#dde1eb
palette = 16=#f4b285
palette = 17=#d3a9dd
palette = 18=#111523
palette = 19=#1a1f2d
palette = 20=#62697a
palette = 21=#acb1bd

# Foreground & background colors
background = #0d111d
foreground = #dde1eb
cursor-color = #dde1eb
selection-background = #dde1eb
selection-foreground = #1a1f2d
search-background = #eace8c
search-foreground = #111523
search-selected-background = #f4b285
search-selected-foreground = #111523

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #dde1eb
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #b1deff
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
