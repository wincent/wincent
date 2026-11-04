-- vim: ft=lua
-- Gigavolt theme for Rex
-- Scheme Author: Aidan Swope (http://github.com/Whillikers)
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

local name = "base16-gigavolt"
local variant = "dark"

-- This must match themes/ghostty/base16-gigavolt exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Gigavolt theme for Ghostty
# Scheme Author: Aidan Swope (http://github.com/Whillikers)
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#202126
palette = 1=#ff661a
palette = 2=#f2e6a9
palette = 3=#ffdc2d
palette = 4=#40bfff
palette = 5=#ae94f9
palette = 6=#fb6acb
palette = 7=#e9e7e1
palette = 8=#a1d2e6
palette = 9=#ff661a
palette = 10=#f2e6a9
palette = 11=#ffdc2d
palette = 12=#40bfff
palette = 13=#ae94f9
palette = 14=#fb6acb
palette = 15=#f2fbff
palette = 16=#19f988
palette = 17=#6187ff
palette = 18=#2d303d
palette = 19=#5a576e
palette = 20=#cad3ff
palette = 21=#eff0f9

# Foreground & background colors
background = #202126
foreground = #e9e7e1
cursor-color = #e9e7e1
selection-background = #e9e7e1
selection-foreground = #5a576e
search-background = #ffdc2d
search-foreground = #2d303d
search-selected-background = #19f988
search-selected-foreground = #2d303d

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #f2fbff
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #40bfff
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
