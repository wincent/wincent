-- vim: ft=lua
-- Embarcadero theme for Rex
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

local name = "base24-embarcadero"
local variant = "dark"

-- This must match themes/ghostty/base24-embarcadero exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Embarcadero theme for Ghostty
# Scheme Author: Thomas Leon Highbaugh
# Scheme System: base24
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#252a2f
palette = 1=#ed5d86
palette = 2=#20c290
palette = 3=#eb824d
palette = 4=#4080d0
palette = 5=#a070d0
palette = 6=#02efef
palette = 7=#bcbdc0
palette = 8=#7f8285
palette = 9=#f57d9a
palette = 10=#a0d0a0
palette = 11=#ffe089
palette = 12=#80b0f0
palette = 13=#c090f0
palette = 14=#40c0c0
palette = 15=#f8f8f8
palette = 16=#ffcb3d
palette = 17=#50509f
palette = 18=#43474c
palette = 19=#616568
palette = 20=#9ea0a2
palette = 21=#dadbdb

# Foreground & background colors
background = #252a2f
foreground = #bcbdc0
cursor-color = #bcbdc0
selection-background = #bcbdc0
selection-foreground = #616568
search-background = #eb824d
search-foreground = #43474c
search-selected-background = #ffcb3d
search-selected-foreground = #43474c

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #f8f8f8
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #80b0f0
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
