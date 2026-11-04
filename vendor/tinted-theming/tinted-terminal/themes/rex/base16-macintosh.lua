-- vim: ft=lua
-- Macintosh theme for Rex
-- Scheme Author: Rebecca Bettencourt (http://www.kreativekorp.com)
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

local name = "base16-macintosh"
local variant = "dark"

-- This must match themes/ghostty/base16-macintosh exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Macintosh theme for Ghostty
# Scheme Author: Rebecca Bettencourt (http://www.kreativekorp.com)
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#000000
palette = 1=#dd0907
palette = 2=#1fb714
palette = 3=#fbf305
palette = 4=#0000d3
palette = 5=#4700a5
palette = 6=#02abea
palette = 7=#c0c0c0
palette = 8=#808080
palette = 9=#dd0907
palette = 10=#1fb714
palette = 11=#fbf305
palette = 12=#0000d3
palette = 13=#4700a5
palette = 14=#02abea
palette = 15=#ffffff
palette = 16=#ff6403
palette = 17=#90713a
palette = 18=#404040
palette = 19=#404040
palette = 20=#808080
palette = 21=#c0c0c0

# Foreground & background colors
background = #000000
foreground = #c0c0c0
cursor-color = #c0c0c0
selection-background = #c0c0c0
selection-foreground = #404040
search-background = #fbf305
search-foreground = #404040
search-selected-background = #ff6403
search-selected-foreground = #404040

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #ffffff
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #0000d3
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
