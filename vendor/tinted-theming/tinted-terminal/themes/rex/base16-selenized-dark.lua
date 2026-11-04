-- vim: ft=lua
-- selenized-dark theme for Rex
-- Scheme Author: Jan Warchol (https://github.com/jan-warchol/selenized) / adapted to base16 by ali
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

local name = "base16-selenized-dark"
local variant = "dark"

-- This must match themes/ghostty/base16-selenized-dark exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# selenized-dark theme for Ghostty
# Scheme Author: Jan Warchol (https://github.com/jan-warchol/selenized) / adapted to base16 by ali
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#103c48
palette = 1=#fa5750
palette = 2=#75b938
palette = 3=#dbb32d
palette = 4=#4695f7
palette = 5=#af88eb
palette = 6=#41c7b9
palette = 7=#adbcbc
palette = 8=#72898f
palette = 9=#fa5750
palette = 10=#75b938
palette = 11=#dbb32d
palette = 12=#4695f7
palette = 13=#af88eb
palette = 14=#41c7b9
palette = 15=#cad8d9
palette = 16=#ed8649
palette = 17=#f275be
palette = 18=#184956
palette = 19=#2d5b69
palette = 20=#72898f
palette = 21=#cad8d9

# Foreground & background colors
background = #103c48
foreground = #adbcbc
cursor-color = #adbcbc
selection-background = #adbcbc
selection-foreground = #2d5b69
search-background = #dbb32d
search-foreground = #184956
search-selected-background = #ed8649
search-selected-foreground = #184956

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #cad8d9
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #4695f7
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
