-- vim: ft=lua
-- SAGA theme for Rex
-- Scheme Author: https://github.com/SAGAtheme/SAGA
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

local name = "base16-saga"
local variant = "dark"

-- This must match themes/ghostty/base16-saga exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# SAGA theme for Ghostty
# Scheme Author: https://github.com/SAGAtheme/SAGA
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#05080a
palette = 1=#ffd4e9
palette = 2=#f7ddff
palette = 3=#fbebc8
palette = 4=#c9fff7
palette = 5=#dcc3f9
palette = 6=#c5edc1
palette = 7=#dce2f7
palette = 8=#141f27
palette = 9=#ffd4e9
palette = 10=#f7ddff
palette = 11=#fbebc8
palette = 12=#c9fff7
palette = 13=#dcc3f9
palette = 14=#c5edc1
palette = 15=#ccd3fe
palette = 16=#fbcbae
palette = 17=#f6dddd
palette = 18=#0a1014
palette = 19=#0f181e
palette = 20=#192630
palette = 21=#f8eae7

# Foreground & background colors
background = #05080a
foreground = #dce2f7
cursor-color = #dce2f7
selection-background = #dce2f7
selection-foreground = #0f181e
search-background = #fbebc8
search-foreground = #0a1014
search-selected-background = #fbcbae
search-selected-foreground = #0a1014

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #ccd3fe
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #c9fff7
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
