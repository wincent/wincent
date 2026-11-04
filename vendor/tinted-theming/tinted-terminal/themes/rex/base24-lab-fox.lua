-- vim: ft=lua
-- Lab Fox theme for Rex
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

local name = "base24-lab-fox"
local variant = "dark"

-- This must match themes/ghostty/base24-lab-fox exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Lab Fox theme for Ghostty
# Scheme Author: FredHappyface (https://github.com/fredHappyface)
# Scheme System: base24
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#2e2e2e
palette = 1=#fc6d26
palette = 2=#3eb383
palette = 3=#db501f
palette = 4=#db3b21
palette = 5=#380d75
palette = 6=#6e49cb
palette = 7=#cfd0d0
palette = 8=#737373
palette = 9=#ff6517
palette = 10=#52e9a8
palette = 11=#fca012
palette = 12=#db501f
palette = 13=#441090
palette = 14=#7d53e7
palette = 15=#feffff
palette = 16=#fca121
palette = 17=#7e3613
palette = 18=#2e2e2e
palette = 19=#454545
palette = 20=#a1a2a2
palette = 21=#feffff

# Foreground & background colors
background = #2e2e2e
foreground = #cfd0d0
cursor-color = #cfd0d0
selection-background = #cfd0d0
selection-foreground = #454545
search-background = #db501f
search-foreground = #2e2e2e
search-selected-background = #fca121
search-selected-foreground = #2e2e2e

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #feffff
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #db501f
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
