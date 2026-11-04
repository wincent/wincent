-- vim: ft=lua
-- Cyberpunk theme for Rex
-- Scheme Author: benjujo
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

local name = "base16-cyberpunk"
local variant = "dark"

-- This must match themes/ghostty/base16-cyberpunk exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Cyberpunk theme for Ghostty
# Scheme Author: benjujo
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#000000
palette = 1=#ff0000
palette = 2=#61ce3c
palette = 3=#ffff00
palette = 4=#4c83ff
palette = 5=#ff1493
palette = 6=#93e0e3
palette = 7=#dcdccc
palette = 8=#4f4f4f
palette = 9=#ff0000
palette = 10=#61ce3c
palette = 11=#ffff00
palette = 12=#4c83ff
palette = 13=#ff1493
palette = 14=#93e0e3
palette = 15=#ffffff
palette = 16=#ffa500
palette = 17=#ff8c00
palette = 18=#2b2b2b
palette = 19=#383838
palette = 20=#8b8989
palette = 21=#f8f8f8

# Foreground & background colors
background = #000000
foreground = #dcdccc
cursor-color = #dcdccc
selection-background = #dcdccc
selection-foreground = #383838
search-background = #ffff00
search-foreground = #2b2b2b
search-selected-background = #ffa500
search-selected-foreground = #2b2b2b

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #ffffff
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #4c83ff
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
