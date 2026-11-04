-- vim: ft=lua
-- Ayu Dark theme for Rex
-- Scheme Author: Tinted Theming (https://github.com/tinted-theming), Ayu Theme (https://github.com/ayu-theme)
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

local name = "base24-ayu-dark"
local variant = "dark"

-- This must match themes/ghostty/base24-ayu-dark exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Ayu Dark theme for Ghostty
# Scheme Author: Tinted Theming (https://github.com/tinted-theming), Ayu Theme (https://github.com/ayu-theme)
# Scheme System: base24
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#0b0e14
palette = 1=#f07178
palette = 2=#aad94c
palette = 3=#ffb454
palette = 4=#59c2ff
palette = 5=#d2a6ff
palette = 6=#95e6cb
palette = 7=#e6e1cf
palette = 8=#3e4b59
palette = 9=#f26d78
palette = 10=#7fd962
palette = 11=#e6b673
palette = 12=#73b8ff
palette = 13=#ddbcff
palette = 14=#39bae6
palette = 15=#f2f0e7
palette = 16=#ff8f40
palette = 17=#e6b450
palette = 18=#131721
palette = 19=#202229
palette = 20=#bfbdb6
palette = 21=#ece8db

# Foreground & background colors
background = #0b0e14
foreground = #e6e1cf
cursor-color = #e6e1cf
selection-background = #e6e1cf
selection-foreground = #202229
search-background = #ffb454
search-foreground = #131721
search-selected-background = #ff8f40
search-selected-foreground = #131721

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #f2f0e7
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #73b8ff
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
