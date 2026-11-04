-- vim: ft=lua
-- Decaf theme for Rex
-- Scheme Author: Alex Mirrington (https://github.com/alexmirrington)
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

local name = "base16-decaf"
local variant = "dark"

-- This must match themes/ghostty/base16-decaf exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Decaf theme for Ghostty
# Scheme Author: Alex Mirrington (https://github.com/alexmirrington)
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#2d2d2d
palette = 1=#ff7f7b
palette = 2=#beda78
palette = 3=#ffd67c
palette = 4=#90bee1
palette = 5=#efb3f7
palette = 6=#bed6ff
palette = 7=#cccccc
palette = 8=#777777
palette = 9=#ff7f7b
palette = 10=#beda78
palette = 11=#ffd67c
palette = 12=#90bee1
palette = 13=#efb3f7
palette = 14=#bed6ff
palette = 15=#ffffff
palette = 16=#ffbf70
palette = 17=#ff93b3
palette = 18=#393939
palette = 19=#515151
palette = 20=#b4b7b4
palette = 21=#e0e0e0

# Foreground & background colors
background = #2d2d2d
foreground = #cccccc
cursor-color = #cccccc
selection-background = #cccccc
selection-foreground = #515151
search-background = #ffd67c
search-foreground = #393939
search-selected-background = #ffbf70
search-selected-foreground = #393939

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #ffffff
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #90bee1
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
