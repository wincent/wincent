-- vim: ft=lua
-- Windows 95 Light theme for Rex
-- Scheme Author: Fergus Collins (https://github.com/ferguscollins)
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

local name = "base16-windows-95-light"
local variant = "light"

-- This must match themes/ghostty/base16-windows-95-light exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Windows 95 Light theme for Ghostty
# Scheme Author: Fergus Collins (https://github.com/ferguscollins)
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#fcfcfc
palette = 1=#a80000
palette = 2=#00a800
palette = 3=#a85400
palette = 4=#0000a8
palette = 5=#a800a8
palette = 6=#00a8a8
palette = 7=#545454
palette = 8=#a8a8a8
palette = 9=#a80000
palette = 10=#00a800
palette = 11=#a85400
palette = 12=#0000a8
palette = 13=#a800a8
palette = 14=#00a8a8
palette = 15=#000000
palette = 16=#fcfc54
palette = 17=#54fc54
palette = 18=#e0e0e0
palette = 19=#c4c4c4
palette = 20=#7e7e7e
palette = 21=#2a2a2a

# Foreground & background colors
background = #fcfcfc
foreground = #545454
cursor-color = #545454
selection-background = #545454
selection-foreground = #c4c4c4
search-background = #a85400
search-foreground = #000000
search-selected-background = #fcfc54
search-selected-foreground = #000000

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #000000
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #0000a8
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
