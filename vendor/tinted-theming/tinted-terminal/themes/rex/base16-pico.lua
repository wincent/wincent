-- vim: ft=lua
-- Pico theme for Rex
-- Scheme Author: PICO-8 (http://www.lexaloffle.com/pico-8.php)
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

local name = "base16-pico"
local variant = "dark"

-- This must match themes/ghostty/base16-pico exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Pico theme for Ghostty
# Scheme Author: PICO-8 (http://www.lexaloffle.com/pico-8.php)
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#000000
palette = 1=#ff004d
palette = 2=#00e756
palette = 3=#fff024
palette = 4=#83769c
palette = 5=#ff77a8
palette = 6=#29adff
palette = 7=#5f574f
palette = 8=#008751
palette = 9=#ff004d
palette = 10=#00e756
palette = 11=#fff024
palette = 12=#83769c
palette = 13=#ff77a8
palette = 14=#29adff
palette = 15=#fff1e8
palette = 16=#ffa300
palette = 17=#ffccaa
palette = 18=#1d2b53
palette = 19=#7e2553
palette = 20=#ab5236
palette = 21=#c2c3c7

# Foreground & background colors
background = #000000
foreground = #5f574f
cursor-color = #5f574f
selection-background = #5f574f
selection-foreground = #7e2553
search-background = #fff024
search-foreground = #1d2b53
search-selected-background = #ffa300
search-selected-foreground = #1d2b53

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #fff1e8
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #83769c
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
