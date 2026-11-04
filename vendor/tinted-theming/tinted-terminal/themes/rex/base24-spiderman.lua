-- vim: ft=lua
-- Spiderman theme for Rex
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

local name = "base24-spiderman"
local variant = "dark"

-- This must match themes/ghostty/base24-spiderman exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Spiderman theme for Ghostty
# Scheme Author: FredHappyface (https://github.com/fredHappyface)
# Scheme System: base24
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#1b1d1e
palette = 1=#e60712
palette = 2=#e22828
palette = 3=#1d4fff
palette = 4=#2b3fff
palette = 5=#2435db
palette = 6=#3255ff
palette = 7=#d3d3cd
palette = 8=#7b7d7c
palette = 9=#ff0325
palette = 10=#ff3238
palette = 11=#fe3935
palette = 12=#1d4fff
palette = 13=#737bff
palette = 14=#6083ff
palette = 15=#fefff9
palette = 16=#e24655
palette = 17=#730309
palette = 18=#1b1d1e
palette = 19=#505354
palette = 20=#a7a8a5
palette = 21=#fffef6

# Foreground & background colors
background = #1b1d1e
foreground = #d3d3cd
cursor-color = #d3d3cd
selection-background = #d3d3cd
selection-foreground = #505354
search-background = #1d4fff
search-foreground = #1b1d1e
search-selected-background = #e24655
search-selected-foreground = #1b1d1e

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #fefff9
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #1d4fff
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
