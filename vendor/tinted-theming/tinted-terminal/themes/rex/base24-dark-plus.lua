-- vim: ft=lua
-- Dark Plus theme for Rex
-- Scheme Author: FredHappyface (https://github.com/fredHappyface)
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

local name = "base24-dark-plus"
local variant = "dark"

-- This must match themes/ghostty/base24-dark-plus exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Dark Plus theme for Ghostty
# Scheme Author: FredHappyface (https://github.com/fredHappyface)
# Scheme System: base24
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#0e0e0e
palette = 1=#cd3131
palette = 2=#0dbc79
palette = 3=#3b8eea
palette = 4=#2472c8
palette = 5=#bc3fbc
palette = 6=#11a8cd
palette = 7=#c5c5c5
palette = 8=#858585
palette = 9=#f14c4c
palette = 10=#23d18b
palette = 11=#f5f543
palette = 12=#3b8eea
palette = 13=#d670d6
palette = 14=#29b8db
palette = 15=#e5e5e5
palette = 16=#e5e510
palette = 17=#661818
palette = 18=#000000
palette = 19=#666666
palette = 20=#a5a5a5
palette = 21=#e5e5e5

# Foreground & background colors
background = #0e0e0e
foreground = #c5c5c5
cursor-color = #c5c5c5
selection-background = #c5c5c5
selection-foreground = #666666
search-background = #3b8eea
search-foreground = #000000
search-selected-background = #e5e510
search-selected-foreground = #000000

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #e5e5e5
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #3b8eea
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
