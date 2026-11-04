-- vim: ft=lua
-- Silk Dark theme for Rex
-- Scheme Author: Gabriel Fontes (https://github.com/Misterio77)
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

local name = "base16-silk-dark"
local variant = "dark"

-- This must match themes/ghostty/base16-silk-dark exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Silk Dark theme for Ghostty
# Scheme Author: Gabriel Fontes (https://github.com/Misterio77)
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#0e3c46
palette = 1=#fb6953
palette = 2=#73d8ad
palette = 3=#fce380
palette = 4=#46bddd
palette = 5=#756b8a
palette = 6=#3fb2b9
palette = 7=#c7dbdd
palette = 8=#587073
palette = 9=#fb6953
palette = 10=#73d8ad
palette = 11=#fce380
palette = 12=#46bddd
palette = 13=#756b8a
palette = 14=#3fb2b9
palette = 15=#d2faff
palette = 16=#fcab74
palette = 17=#9b647b
palette = 18=#1d494e
palette = 19=#2a5054
palette = 20=#9dc8cd
palette = 21=#cbf2f7

# Foreground & background colors
background = #0e3c46
foreground = #c7dbdd
cursor-color = #c7dbdd
selection-background = #c7dbdd
selection-foreground = #2a5054
search-background = #fce380
search-foreground = #1d494e
search-selected-background = #fcab74
search-selected-foreground = #1d494e

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #d2faff
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #46bddd
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
