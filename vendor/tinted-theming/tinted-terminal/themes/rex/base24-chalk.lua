-- vim: ft=lua
-- Chalk theme for Rex
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

local name = "base24-chalk"
local variant = "dark"

-- This must match themes/ghostty/base24-chalk exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Chalk theme for Ghostty
# Scheme Author: FredHappyface (https://github.com/fredHappyface)
# Scheme System: base24
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#151515
palette = 1=#fa859c
palette = 2=#a1bb54
palette = 3=#ddb26f
palette = 4=#5ab9ed
palette = 5=#db8fea
palette = 6=#10bcad
palette = 7=#d0d0d0
palette = 8=#505050
palette = 9=#fb9fb1
palette = 10=#acc267
palette = 11=#eda987
palette = 12=#6fc2ef
palette = 13=#e1a3ee
palette = 14=#12cfc0
palette = 15=#f5f5f5
palette = 16=#ea9971
palette = 17=#deaf8f
palette = 18=#202020
palette = 19=#303030
palette = 20=#b0b0b0
palette = 21=#e0e0e0

# Foreground & background colors
background = #151515
foreground = #d0d0d0
cursor-color = #d0d0d0
selection-background = #d0d0d0
selection-foreground = #303030
search-background = #ddb26f
search-foreground = #202020
search-selected-background = #ea9971
search-selected-foreground = #202020

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #f5f5f5
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #6fc2ef
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
