-- vim: ft=lua
-- Swamp Dark theme for Rex
-- Scheme Author: Masroof Maindak (https://github.com/masroof-maindak)
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

local name = "base16-swamp-dark"
local variant = "dark"

-- This must match themes/ghostty/base16-swamp-dark exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Swamp Dark theme for Ghostty
# Scheme Author: Masroof Maindak (https://github.com/masroof-maindak)
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#242015
palette = 1=#db930d
palette = 2=#7a7653
palette = 3=#a82d56
palette = 4=#c1666b
palette = 5=#91506c
palette = 6=#db930d
palette = 7=#d2c3a4
palette = 8=#5f4e41
palette = 9=#db930d
palette = 10=#7a7653
palette = 11=#a82d56
palette = 12=#c1666b
palette = 13=#91506c
palette = 14=#db930d
palette = 15=#f1e9d0
palette = 16=#ebe0bb
palette = 17=#61a0a8
palette = 18=#3a3124
palette = 19=#4d3f32
palette = 20=#b8a58c
palette = 21=#ebe0bb

# Foreground & background colors
background = #242015
foreground = #d2c3a4
cursor-color = #d2c3a4
selection-background = #d2c3a4
selection-foreground = #4d3f32
search-background = #a82d56
search-foreground = #3a3124
search-selected-background = #ebe0bb
search-selected-foreground = #3a3124

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #f1e9d0
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #c1666b
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
