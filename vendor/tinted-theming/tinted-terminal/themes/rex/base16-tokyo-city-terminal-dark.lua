-- vim: ft=lua
-- Tokyo City Terminal Dark theme for Rex
-- Scheme Author: Michaël Ball
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

local name = "base16-tokyo-city-terminal-dark"
local variant = "dark"

-- This must match themes/ghostty/base16-tokyo-city-terminal-dark exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Tokyo City Terminal Dark theme for Ghostty
# Scheme Author: Michaël Ball
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#171d23
palette = 1=#d95468
palette = 2=#8bd49c
palette = 3=#ebbf83
palette = 4=#539afc
palette = 5=#b62d65
palette = 6=#70e1e8
palette = 7=#d8e2ec
palette = 8=#526270
palette = 9=#d95468
palette = 10=#8bd49c
palette = 11=#ebbf83
palette = 12=#539afc
palette = 13=#b62d65
palette = 14=#70e1e8
palette = 15=#fbfbfd
palette = 16=#ff9e64
palette = 17=#dd9d82
palette = 18=#1d252c
palette = 19=#28323a
palette = 20=#b7c5d3
palette = 21=#f6f6f8

# Foreground & background colors
background = #171d23
foreground = #d8e2ec
cursor-color = #d8e2ec
selection-background = #d8e2ec
selection-foreground = #28323a
search-background = #ebbf83
search-foreground = #1d252c
search-selected-background = #ff9e64
search-selected-foreground = #1d252c

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #fbfbfd
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #539afc
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
