-- vim: ft=lua
-- Crayon Pony Fish theme for Rex
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

local name = "base24-crayon-pony-fish"
local variant = "dark"

-- This must match themes/ghostty/base24-crayon-pony-fish exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Crayon Pony Fish theme for Ghostty
# Scheme Author: FredHappyface (https://github.com/fredHappyface)
# Scheme System: base24
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#140607
palette = 1=#90002a
palette = 2=#579523
palette = 3=#cfc9ff
palette = 4=#8b87af
palette = 5=#682e50
palette = 6=#e8a766
palette = 7=#5d484e
palette = 8=#473438
palette = 9=#c5245c
palette = 10=#8dff56
palette = 11=#c7371d
palette = 12=#cfc9ff
palette = 13=#fb6cb9
palette = 14=#ffceae
palette = 15=#af949d
palette = 16=#aa301b
palette = 17=#480015
palette = 18=#2a1a1c
palette = 19=#3c2a2e
palette = 20=#523e43
palette = 21=#685259

# Foreground & background colors
background = #140607
foreground = #5d484e
cursor-color = #5d484e
selection-background = #5d484e
selection-foreground = #3c2a2e
search-background = #cfc9ff
search-foreground = #2a1a1c
search-selected-background = #aa301b
search-selected-foreground = #2a1a1c

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #af949d
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #cfc9ff
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
