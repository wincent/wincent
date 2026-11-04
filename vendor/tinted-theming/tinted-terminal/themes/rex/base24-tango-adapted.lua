-- vim: ft=lua
-- Tango Adapted theme for Rex
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

local name = "base24-tango-adapted"
local variant = "light"

-- This must match themes/ghostty/base24-tango-adapted exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Tango Adapted theme for Ghostty
# Scheme Author: FredHappyface (https://github.com/fredHappyface)
# Scheme System: base24
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#feffff
palette = 1=#ff0000
palette = 2=#59d500
palette = 3=#efca00
palette = 4=#00a1ff
palette = 5=#c17ecb
palette = 6=#00d0d6
palette = 7=#4f4f4f
palette = 8=#cccccc
palette = 9=#ff0012
palette = 10=#93fe00
palette = 11=#fff021
palette = 12=#88c9ff
palette = 13=#e8a6e1
palette = 14=#00fdff
palette = 15=#000000
palette = 16=#ef9b00
palette = 17=#7f0000
palette = 18=#f1f1f1
palette = 19=#dcdcdc
palette = 20=#757575
palette = 21=#323232

# Foreground & background colors
background = #feffff
foreground = #4f4f4f
cursor-color = #4f4f4f
selection-background = #4f4f4f
selection-foreground = #dcdcdc
search-background = #efca00
search-foreground = #f1f1f1
search-selected-background = #ef9b00
search-selected-foreground = #f1f1f1

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #000000
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #88c9ff
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
