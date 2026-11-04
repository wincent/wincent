-- vim: ft=lua
-- Nord theme for Rex
-- Scheme Author: Tinted Theming (https://github.com/tinted-theming)
-- Scheme System: tinted8
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

local name = "tinted8-nord"
local variant = "dark"

-- This must match themes/ghostty/tinted8-nord exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Nord theme for Ghostty
# Scheme Author: Tinted Theming (https://github.com/tinted-theming)
# Scheme System: tinted8
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#2e3440
palette = 1=#bf616a
palette = 2=#a3be8c
palette = 3=#ebcb8b
palette = 4=#81a1c1
palette = 5=#b48ead
palette = 6=#88c0d0
palette = 7=#e5e9f0
palette = 8=#465165
palette = 9=#d18d93
palette = 10=#c2d4b3
palette = 11=#f4e2bf
palette = 12=#aac0d5
palette = 13=#ccb3c8
palette = 14=#b4d7e1
palette = 15=#eceff4

# Foreground & background colors
background = #2e3440
foreground = #e5e9f0
cursor-color = #e5e9f0
selection-background = #465165
selection-foreground = #e5e9f0

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #eceff4
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #aac0d5
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
