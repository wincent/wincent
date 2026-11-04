-- vim: ft=lua
-- Blue Forest theme for Rex
-- Scheme Author: alonsodomin (https://github.com/alonsodomin)
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

local name = "base16-blueforest"
local variant = "dark"

-- This must match themes/ghostty/base16-blueforest exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Blue Forest theme for Ghostty
# Scheme Author: alonsodomin (https://github.com/alonsodomin)
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#141f2e
palette = 1=#fffab1
palette = 2=#80ff80
palette = 3=#91ccff
palette = 4=#a2cff5
palette = 5=#0099ff
palette = 6=#80ff80
palette = 7=#ffcc33
palette = 8=#a0ffa0
palette = 9=#fffab1
palette = 10=#80ff80
palette = 11=#91ccff
palette = 12=#a2cff5
palette = 13=#0099ff
palette = 14=#80ff80
palette = 15=#375780
palette = 16=#ff8080
palette = 17=#e7e7e7
palette = 18=#1e5c1e
palette = 19=#273e5c
palette = 20=#1e5c1e
palette = 21=#91ccff

# Foreground & background colors
background = #141f2e
foreground = #ffcc33
cursor-color = #ffcc33
selection-background = #ffcc33
selection-foreground = #273e5c
search-background = #91ccff
search-foreground = #1e5c1e
search-selected-background = #ff8080
search-selected-foreground = #1e5c1e

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #375780
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #a2cff5
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
